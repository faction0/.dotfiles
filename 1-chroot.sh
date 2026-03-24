#!/bin/bash

DF_DIR="/root/.dotfiles"
DF_ASS="/root/.dotfiles/assets"

echo "======== setting root password ========"
passwd root

echo "======== adding wheel to sudoers ========"
echo "%wheel ALL=(ALL:ALL) ALL" | tee /etc/sudoers.d/10-wheel >/dev/null
chmod 440 /etc/sudoers.d/10-wheel
visudo -c

echo "======== adding user and running main script ========"

useradd -mG wheel faction

echo "======== setting faction password ========"
passwd faction

echo "======== moving dotfiles ========"
cp -r $DF_DIR /home/faction/

chown -hR faction /home/faction/.dotfiles

echo "======== copying root files ========"
cp "${DF_ASS}/grub-default.cfg" /etc/default/grub
cp "${DF_ASS}/timesyncd.conf"   /etc/systemd/timesyncd.conf

7z x "${DF_ASS}/0xProto.7z"    "-o/usr/share/fonts/"
7z x "${DF_ASS}/CommitMono.7z" "-o/usr/share/fonts/"

echo "======== setting up grub ========"

mkdir -p /boot/EFI/Arch
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Arch
grub-mkconfig -o /boot/grub/grub.cfg

echo "======== setting up localtime ========"

ln -sf /usr/share/zoneinfo/America/Santiago /etc/localtime
timedatectl set-ntp true

echo "======== misc ========"

cp -v "${DF_ASS}/pacman.conf" /etc/pacman.conf

echo "type hostname"
read i_hostname

echo "$i_hostname" > /etc/hostname

echo "ok. now reboot, log as faction, modprobe nouveau, startx, run alacritty, then run 2-from-terminal.sh"
