#!/bin/bash

# Install packages with pacman
sudo pacman -S --noconfirm \
    android-tools \
    bat htop neofetch tldr wget \
    bluez bluez-utils blueman \
    neovim \
    distrobox docker \
    flatpak \
    gcc jre-openjdk-headless \
    git github-cli \
    gnome-themes-extra \
    noto-fonts-cjk noto-fonts-extra \
    nvidia-dkms

# Enable bluetooth
systemctl enable --now bluetooth

# Install yay and their packages
git clone https://aur.archlinux.org/yay.git && cd yay
makepkg -si
cd .. && rm -rf yay

yay -S --noconfirm \
    google-chrome \
    visual-studio-code-bin

# Install Flatpak applications
flatpak install flathub -y \
    com.discordapp.Discord \
    com.mattjakeman.ExtensionManager \
    de.haeckerfelix.Fragments \
    io.github.colluloid_player.Celluloid \
    net.agalwood.Mortix \
    org.libreoffice.LibreOffice \
    org.telegram.desktop

# Import the PGP key for asusctl
pacman-key --recv-keys 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
pacman-key --lsign-key 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35

# Add the custom repository to /etc/pacman.conf
echo -e "\n[g14]\nServer = https://arch.asus-linux.org" | sudo tee -a /etc/pacman.conf
sudo pacman -Syu --noconfirm

sudo pacman -S asusctl --noconfirm
systemctl enable --now power-profiles-daemon.service

sudo pacman -S supergfxctl
systemctl enable --now supergfxd

# Install battop
wget https://github.com/svartalf/rust-battop/releases/download/v0.2.4/battop-v0.2.4-x86_64-unknown-linux-gnu -O battop
sudo mv battop /usr/bin/
sudo chmod +x /usr/bin/battop

# Add the user to the docker group
sudo usermod -aG docker $USER
sudo systemctl enable --now docker

# Set Git aliases and other configurations
if [[ $USER == "karan" ]]; then
  git config --global user.email "karan@pixelos.net"
  git config --global user.name "Karan Parashar"
fi

git config --global alias.cp 'cherry-pick'
git config --global alias.c 'commit'
git config --global alias.f 'fetch'
git config --global alias.m 'merge'
git config --global alias.rb 'rebase'
git config --global alias.rs 'reset'
git config --global alias.ck 'checkout'
git config --global core.editor "nvim"

# Install patched Nerd Fonts
mkdir -p ~/.fonts
wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip" -O JetBrainsMono.zip
unzip JetBrainsMono.zip -d ~/.fonts/
rm JetBrainsMono.zip
fc-cache -fv

# Clone the NvChad repository
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 --quiet

# Configure GNOME settings
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
