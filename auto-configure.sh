#!/bin/bash
set -e
echo "Changing umask permissions..."
umask 0027

date
echo "Please ensure the time and date are set properly!"
sleep 5

echo "Setting up https secured mirrors only"
cat confs/etc-pacman-d-mirrorlist > /etc/pacman.d/mirrorlist

### Modification inside our 
echo "Setting up Language preferences..."
cat confs/etc-locale-gen > /etc/locale.gen
cat confs/etc-locale-conf > /etc/locale.conf
locale-gen

echo "Setting Environmental variables for Language options..."
export LANG=C
export LANGUAGE=en_GB

loadkeys /usr/share/kbd/keymaps/i386/qwerty/uk.map.gz

echo "Setting up WPA Supplicant..."
cat confs/etc-wpa_supplicant-wpa-supplicant-conf > /etc/wpa_supplicant/wpa_supplicant.conf
echo "Cleaning up any previous wireless sessions and dependencies."
ifconfig wlp2s0 down && killall wpa_supplicant && killall dhclient
echo "Interface and session cleanup completed"
echo "Bringing up wireless interface.."
ifconfig wlp2s0 up && wpa_supplicant -iwlp2s0 -c/etc/wpa_supplicant/wpa_supplicant.conf -B && dhclient wlp2s0 -nw
echo "Wireless configuration complete."
echo "Waiting for DHCP Lease..."
sleep 20
echo "DHCP Lease should be ready"

echo "Creating Directories and Mount points..."

mount /dev/mapper/root /mnt
sleep 2

mkdir /mnt/boot
mkdir /mnt/home
mkdir /mnt/var
mkdir /mnt/media

mount -o acl /dev/mapper/home /mnt/home
sleep 2

mount -o acl /dev/mapper/var /mnt/var
sleep 2

mount -o acl /dev/sda2 /mnt/boot
sleep 2

mkdir /mnt/boot/efi

mount /dev/sda1 /mnt/boot/efi
sleep 2

# We have to initialize a keyring before we can do any of this...

gpg2 --refresh-keys

echo "Refreshing keys for packages"
# Same thing goes for pacmans key ring...
pacman-key --init
pacman-key --refresh-keys --keyserver pgp.mit.edu
sleep 1
echo "Key update for packages completed"
sleep 5
pacman-key --updatedb

cat confs/etc-makepkg-conf > /etc/makepkg.conf

echo "PACMan update initialising..."
pacman -Sy
echo "Running Installation package update finished..."
pacstrap /mnt base hardening-wrapper
sleep 3

# Yes done a second time to make sure it is not overwritten..."
cat confs/etc-makepkg-conf > /mnt/etc/makepkg.conf

# Insure Kernel is generated correctly during update..."
cat confs/etc-mkinitcpio-conf > /mnt/etc/mkinitcpio.conf

pacstrap /mnt libsystemd systemd systemd-swap  
sleep 3
pacstrap /mnt device-mapper btrfs-progs lvm2 dosfstools 
sleep 3
pacstrap /mnt busybox inxi dmidecode
sleep 3
pacstrap /mnt base-devel arch-install-scripts
sleep 3
# Extra packages for kernel compilation...
pacstrap /mnt xmlto docbook-xsl kmod inetutils bc crda ed
sleep 1
pacstrap /mnt bash bashdb bash-docs 
sleep 2
pacstrap /mnt zsh grml-zsh-config
sleep 2
pacstrap /mnt sudo intel-ucode mkinitcpio htop strace tcpdump openssh net-tools
sleep 2
pacstrap /mnt checksec lynis rkhunter
sleep 2
pacstrap /mnt arptables iptables
sleep 2
pacstrap /mnt quota-tools wpa_supplicant dialog
sleep 2
pacstrap /mnt qemu qemu-arch-extra
sleep 2
pacstrap /mnt xorg xfce4 xfce4-goodies ffmpeg ffmpegthumbnailer libodfgen poppler-glib poppler-data libgsf libopenraw 
sleep 2
pacstrap /mnt grsec-common linux-grsec-headers linux-grsec
sleep 2
pacstrap /mnt paxd pax-utils paxtest gradm
sleep 2
pacstrap /mnt efibootmgr 
sleep 2
pacstrap /mnt logrotate aide
##########################################################################################
echo "Running installation package update completed!"
sleep 2

echo "Applying Hardened configuration files"
cat confs/etc-aide-conf > /mnt/etc/aide.conf
cat confs/etc-bash-bashrc > /mnt/etc/bash.bashrc
cat confs/etc-conf-d-wireless-regdom > /mnt/etc/conf.d/wireless-regdom
cat confs/etc-crypttab > /mnt/etc/crypttab
cat confs/etc-default-passwd > /mnt/etc/default/passwd
cat confs/etc-default-useradd > /mnt/etc/default/useradd
cat confs/etc-dhclient-conf > /mnt/etc/dhclient.conf
cat confs/etc-environment > /mnt/etc/environment
cat confs/etc-fstab > /mnt/etc/fstab
cat confs/etc-hardening-wrapper-conf > /mnt/etc/hardening-wrapper.conf
cat confs/etc-iptables-ip6tables.rules > /mnt/etc/iptables/ip6tables.rules
cat confs/etc-iptables-iptables.rules > /mnt/etc/iptables/iptables.rules
cat confs/etc-issue > /mnt/etc/issue
cat confs/etc-issue-net > /mnt/etc/issue.net
cat confs/etc-locale-conf > /mnt/etc/locale.conf
cat confs/etc-locale-gen > /mnt/etc/locale.gen
cat confs/etc-login-defs > /mnt/etc/login.defs
cat confs/etc-logrotate-conf > /mnt/etc/logrotate.conf
cat confs/etc-lynis-default-prf > /mnt/etc/lynis/default.prf
cat confs/etc-mkinitcpio-conf > /mnt/etc/mkinitcpio.conf
cat confs/etc-modprobe-d-blacklist-firewire > /mnt/etc/modprobe.d/blacklist-firewire
cat confs/etc-modprobe-d-blacklist-usb > /mnt/etc/modprobe.d/blacklist-usb
cat confs/etc-motd > /mnt/etc/motd
cat confs/etc-pacman-d-mirrorlist > /mnt/etc/pacman.d/mirrorlist
cat confs/etc-profile > /mnt/etc/profile
cat confs/etc-securetty > /mnt/etc/securetty
cat confs/etc-security-access-conf > /mnt/etc/security/access.conf
cat confs/etc-security-group-conf > /mnt/etc/security/group.conf
cat confs/etc-security-limits-conf > /mnt/etc/security/limits.conf
cat confs/etc-security-namespace-conf > /mnt/etc/security/namespace.conf
cat confs/etc-security-pam-env-conf > /mnt/etc/security/pam-env.conf
cat confs/etc-security-time-conf > /mnt/etc/security/time.conf
cat confs/etc-shells > /mnt/etc/shells
cat confs/etc-ssh-ssh_config > /mnt/etc/ssh/ssh_config
cat confs/etc-ssh-sshd_config > /mnt/etc/ssh/sshd_config
cat confs/etc-sudoers > /mnt/etc/sudoers
cat confs/etc-sysctl-d-05-grsecurity-conf > /mnt/etc/sysctl.d/05-grsecurity.conf
cat confs/etc-sysctl-d-10-sysctl-conf > /mnt/etc/sysctl.d/10-sysctl.conf
cat confs/etc-vconsole-conf > /mnt/etc/vconsole.conf
cat confs/etc-wpa_supplicant-wpa-supplicant-conf > /mnt/etc/wpa_supplicant/wpa-supplicant.conf
cat confs/etc-zsh-zprofile > /mnt/etc/zsh/zprofile
cat confs/etc-zsh-zshrc > /mnt/etc/zsh/zshrc
cat confs/post-install.sh > /mnt/root/post-install.sh

echo "Copying over Firware..."
mkdir /mnt/etc/keys
cp drives/var-key /mnt/etc/keys/
cp drives/swap-key /mnt/etc/keys/
cp drives/home-key /mnt/etc/keys/
chmod 000 /mnt/etc/keys/home-key
chmod 000 /mnt/etc/keys/var-key
chmod 000 /mnt/etc/keys/swap-key

echo "Copying over post install script"
cat confs/post-install.sh > /mnt/root/post-install.sh

#echo "Unmounting mnt volumes..."
#umount -R /mnt
echo "Arch Installation completed!"
exit 0
