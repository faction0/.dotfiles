#!/bin/bash

echo -n "Target disk: /dev/"
read INSTALL_TARGET

echo "using /dev/$INSTALL_TARGET"

echo "======== partitioning ========"
parted -s "/dev/$INSTALL_TARGET" \
    mklabel gpt \
    mkpart primary fat32 0% 1GiB \
    set 1 esp on \
    mkpart primary ext4 1GiB 100%

fdisk -l
echo "Check if partition list is ok then press enter"
read miau

echo "======== mkfs.fat ========"
mkfs.fat -F 32 "/dev/${INSTALL_TARGET}1"

echo "======== mkfs.btrfs ========"
mkfs.ext4 "/dev/${INSTALL_TARGET}2"

echo "======== mounting ========"
mount -v "/dev/${INSTALL_TARGET}2" /mnt
mount -v --mkdir "/dev/${INSTALL_TARGET}1" /mnt/boot

echo "======== pacstrap ========"
pacstrap -K /mnt base base-devel linux linux-firmware linux-headers \
    grub efibootmgr \
    git p7zip \
    rmpc mpd pipewire pipewire-pulse pipewire-alsa wireplumber \
    ttf-roboto ttf-roboto-mono noto-fonts noto-fonts-cjk noto-fonts-emoji \
    qemu-full virt-manager \
    networkmanager dunst xdg-desktop-portal-gnome\
    libreoffice-still gimp rofi \
    feh nemo nnn neovim \
    flatpak locate steam

echo "======== genfstab ========"
genfstab -U /mnt > /mnt/etc/fstab

echo "======== copying dotfiles into installed system ========"
cp -v /root/.dotfiles /mnt/root/

echo "ok. now chroot and run /root/.dotfiles/1-chroot.sh"

