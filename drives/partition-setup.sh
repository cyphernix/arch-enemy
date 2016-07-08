#!/bin/bash

#This script will create all necessary partitions and encrypted lvm volumes for installation
#One thing to note about how this is done is that keys are stored only in the root partition and the root partion is locked with a passphrase.
#This basically insures a layered approach where in order to unlock home, var or swap the root volume must be unlocked first. ;)

set -e

echo "Starting Hardware and partition setup!"
echo "Loading Kernel Modules..."
modprobe dm-crypt
modprobe xts
modprobe serpent_generic
modprobe sha512_generic
modprobe sha256_generic
modprobe twofish_generic
modprobe ext4
modprobe ext2
modprobe vfat

echo "Verifying EFI Variables..."
sleep 3
ls /sys/firmware/efi/efivars
sleep 1

echo "Creating initial disk layout..."
sfdisk /dev/sda < sda-provision
fdisk -l /dev/sda
sleep 3

echo "Creating FAT EFI partition..."
mkfs.vfat -n EFI /dev/sda1

echo "Creating unencrypted BOOT partition..."
mkfs.ext2 -L BOOT /dev/sda2

echo "Setting up physical volume..."
pvcreate /dev/sda3
pvdisplay
sleep 3

echo "Creating volume group vg0..."
vgcreate vg0 /dev/sda3
vgdisplay
sleep 3

echo "Setting up Logical Volumes..."
lvcreate -L 6G -n lvroot vg0
lvcreate -L 6G -n lvvar vg0
lvcreate -L 2G -n lvswap vg0
lvcreate -l 100%FREE -n lvhome vg0
lvdisplay
sleep 3

echo "Creating Keys for Drive Encryption..."
dd bs=512 count=1 if=/dev/urandom of=swap-key iflag=fullblock
dd bs=512 count=2 if=/dev/urandom of=var-key iflag=fullblock
dd bs=512 count=2 if=/dev/urandom of=home-key iflag=fullblock

echo "Setting up LUKS root partition with passphrase..."
# Use /dev/mapper for all encrypted mount points from here on out...
cryptsetup --verify-passphrase=YES --iter-time=18448 --hash=sha256 --cipher=serpent-xts-essiv:sha256 --key-size=512 luksFormat /dev/vg0/lvroot
cryptsetup luksOpen /dev/vg0/lvroot root
sleep 3
cryptsetup status root
ls /dev/mapper/root
cryptsetup luksHeaderBackup /dev/vg0/lvroot --header-backup-file root-header.img
mkfs.ext4 -L ROOT /dev/mapper/root

echo "Setting up home partition with encryption key..."
cryptsetup --iter-time=14864 --hash=sha256 --cipher=serpent-xts-plain64:sha256 --key-size=512 luksFormat /dev/vg0/lvhome --key-file=home-key
cryptsetup luksOpen /dev/vg0/lvhome home --key-file=home-key
sleep 3
cryptsetup status home
ls /dev/mapper/home
cryptsetup luksHeaderBackup /dev/vg0/lvhome --header-backup-file home-header.img
mkfs.ext4 -L HOME /dev/mapper/home

echo "Setting up var partition with encryption key..."
cryptsetup --iter-time=13584 --hash=sha256 --cipher=twofish-xts-plain64:sha256 --key-size=256 luksFormat /dev/vg0/lvvar --key-file=var-key
cryptsetup luksOpen /dev/vg0/lvvar var --key-file=var-key
sleep 3
cryptsetup status var
ls /dev/mapper/var
cryptsetup luksHeaderBackup /dev/vg0/lvvar --header-backup-file var-header.img
mkfs.ext4 -L VAR /dev/mapper/var

echo "Setting up swap partition with seperate encryption key and faster cipher..."
cryptsetup --iter-time=12560 --hash=sha256 --cipher=twofish-xts-plain64:sha256 --key-size=256 luksFormat /dev/vg0/lvswap --key-file=swap-key
cryptsetup luksOpen /dev/vg0/lvswap swap --key-file=swap-key
sleep 3
cryptsetup status swap
ls /dev/mapper/swap
cryptsetup luksHeaderBackup /dev/vg0/lvswap --header-backup-file swap-header.img
mkswap -L SWAP /dev/mapper/swap

echo "Drive provisioning completed!"
exit 0
