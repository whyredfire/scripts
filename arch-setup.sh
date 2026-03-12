#!/bin/bash

# Install packages with pacman
sudo pacman -S --noconfirm \
    android-tools \
    bat htop fastfetch wget \
    neovim \
    flatpak \
    gcc \
    noto-fonts-cjk noto-fonts-extra \
    telegram-desktop discord \
    celluloid

# Setup bluetooth
sudo pacman -S --noconfirm bluez bluez-utils blueman
systemctl enable --now bluetooth

# Setup git
sudo pacman -S --noconfirm git github-cli

if [[ $USER == "karan" ]]; then
  git config --global user.email "whyredfire@gmail.com"
  git config --global user.name "Karan Parashar"
fi

git config --global alias.cp 'cherry-pick'
git config --global alias.c 'commit'
git config --global alias.f 'fetch'
git config --global alias.m 'merge'
git config --global alias.rb 'rebase'
git config --global alias.rs 'reset'
git config --global alias.ck 'checkout'

git config --global commit.verbose true
git config --global core.editor 'nvim'

# Install yay and their packages
git clone https://aur.archlinux.org/yay.git && cd yay
makepkg -si
cd .. && rm -rf yay

yay -S --noconfirm \
    google-chrome \
    motrix-bin

# Install battop
wget https://github.com/svartalf/rust-battop/releases/download/v0.2.4/battop-v0.2.4-x86_64-unknown-linux-gnu -O battop
sudo mv battop /usr/bin/
sudo chmod +x /usr/bin/battop

# Setup docker
sudo pacman -S --noconfirm docker

sudo usermod -aG docker $USER
sudo systemctl enable --now docker

# Configure GNOME shell
sudo pacman -S --noconfirm gnome-themes-extra extension-manager

# gsettings list-recursively org.gnome.desktop.interface
gsettings set org.gnome.shell disable-user-extensions false
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.interface locate-pointer true
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.desktop.interface clock-format '12h'
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font Medium 10'
