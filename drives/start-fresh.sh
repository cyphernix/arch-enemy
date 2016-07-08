#!/bin/bash
cryptsetup luksClose /dev/mapper/root
cryptsetup luksClose /dev/mapper/home
cryptsetup luksClose /dev/mapper/var
cryptsetup luksClose /dev/mapper/swap
cryptsetup luksClose /dev/mapper/crap
cryptsetup erase /dev/mapper/root
cryptsetup erase /dev/mapper/home
cryptsetup erase /dev/mapper/var
cryptsetup erase /dev/mapper/swap
cryptsetup erase /dev/mapper/crap
lvremove /dev/vg0/lvroot
lvremove /dev/vg0/lvswap
lvremove /dev/vg0/lvhome
lvremove /dev/vg0/lvvar
lvremove /dev/vg0/lvcrap
vgremove vg0
pvremove /dev/sda3
wipefs -f -a /dev/sda1
wipefs -f -a /dev/sda2
wipefs -f -a /dev/sda3
wipefs -f -a /dev/sda
rm var-header.img
rm home-header.img
rm swap-header.img
rm home-key
rm swap-key
rm var-key
exit 0
