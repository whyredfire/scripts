#!/bin/bash

# docker
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

## Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

## Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo usermod -aG docker "$USER"

# neovim
sudo wget https://github.com/neovim/neovim/releases/download/v0.11.1/nvim-linux-arm64.appimage -O /usr/local/bin/nvim
sudo chmod +x /usr/local/bin/nvim

# btop
wget https://github.com/aristocratos/btop/releases/download/v1.4.3/btop-aarch64-linux-musl.tbz
tar -xvjf btop-aarch64-linux-musl.tbz
cd btop && sudo make install
rm -rf btop btop-aarch64-linux-musl.tbz

# fastfetch
wget https://github.com/fastfetch-cli/fastfetch/releases/download/2.44.0/fastfetch-linux-aarch64.deb
sudo dpkg -i fastfetch-linux-aarch64.deb
rm fastfetch-linux-aarch64.deb

# apt packages
sudo apt install -y \
  node \
  npm \
  tmux \
  zsh

# git
git config --global user.email "karan.parashar@samey.ai"
git config --global user.name "Karan Parashar"

git config --global alias.cp 'cherry-pick'
git config --global alias.c 'commit'
git config --global alias.f 'fetch'
git config --global alias.m 'merge'
git config --global alias.rb 'rebase'
git config --global alias.rs 'reset'
git config --global alias.ck 'checkout'

git config --global commit.verbose true
git config --global core.editor 'nvim'

# tmux
git clone https://github.com/tmux-plugins/tpm --depth=1 ~/.tmux/plugins/tpm

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# dotfiles
git clone https://github.com/whyredfire/dotfiles dotfiles
cp -r dotfiles/.config/* ~/.config/
rm -rf dotfiles

ZSH_PATH=~/.oh-my-zsh/custom/plugins

git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_PATH/zsh-autosuggestions --depth=1
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_PATH/zsh-syntax-highlighting --depth=1
git clone https://github.com/zsh-users/zsh-completions.git $ZSH_PATH/zsh-completions --depth=1

sudo chsh -s $(which zsh)

