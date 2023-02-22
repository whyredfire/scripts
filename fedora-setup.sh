#!/bin/bash
#
# Script to set up a Fedora 32+ server
# (with minimum 16GB RAM, 8 threads CPU) for android ROM compiling
#
# Sudo access is mandatory to run this script
#
# IMPORTANT NOTICE: This script sets my personal git config, update
# it with your details before you run this script!
#
# Usage:
#	./fedora-setup.sh
#

# Go to home dir
orig_dir=$(pwd)
cd $HOME

echo -e "Installing and updating dnf packages...\n"
sudo dnf update -qq
sudo dnf install -y -qq \
    android-tools autoconf213 bison bzip2 ccache curl flex gawk \
    gcc-c++ git glibc-devel glibc-static libstdc++-static libX11-devel \
    make mesa-libGL-devel ncurses-devel neofetch nload openssl patch \
    zlib-devel ncurses-devel.i686 readline-devel.i686 zlib-devel.i686 \
    libX11-devel.i686 mesa-libGL-devel.i686 glibc-devel.i686 libstdc++.i686 \
    libXrandr.i686 zip perl-Digest-SHA python2 wget lzop openssl-devel \
    java-1.8.0-openjdk-devel ImageMagick ncurses-compat-libs lzip \
    vboot-utils
sudo dnf autoremove -y -qq
echo -e "\nDone."

echo -e "\nInstalling git-repo..."
wget -q https://storage.googleapis.com/git-repo-downloads/repo
chmod a+x repo
sudo install repo /usr/local/bin/repo
rm repo
echo -e "Done."

echo -e "\nInstalling git-cli..."
sudo dnf install 'dnf-command(config-manager)'
sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
sudo dnf install gh
echo -e "Done."

echo -e "\nInstalling Google Drive CLI..."
wget -q https://raw.githubusercontent.com/usmanmughalji/gdriveupload/master/gdrive
chmod a+x gdrive
sudo install gdrive /usr/local/bin/gdrive
rm gdrive
echo -e "Done."

echo -e "\nInstalling apktool and JADX..."
mkdir -p bin
wget -q https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.6.0.jar -O bin/apktool.jar
echo 'alias apktool="java -jar $HOME/bin/apktool.jar"' >> .bashrc

wget -q https://github.com/skylot/jadx/releases/download/v1.4.4/jadx-1.4.4.zip
unzip -qq jadx-1.4.4.zip -d jadx
rm jadx-1.4.4.zip
echo 'export PATH="$HOME/jadx/bin:$PATH"' >> .bashrc
echo -e "Done."

echo -e "\nSetting up shell environment..."
if [[ $SHELL = *zsh* ]]; then
sh_rc=".zshrc"
else
sh_rc=".bashrc"
fi

###
### IMPORTANT !!! REPLACE WITH YOUR PERSONAL DETAILS IF NECESSARY
###
# Configure git
echo -e "\nSetting up Git..."

git config --global user.email "karan@pixelos.net"
git config --global user.name "Karan Parashar"

git config --global alias.cp 'cherry-pick'
git config --global alias.c 'commit'
git config --global alias.f 'fetch'
git config --global alias.rb 'rebase'
git config --global alias.rs 'reset'
git config --global alias.ck 'checkout'
git config --global credential.helper 'cache --timeout=99999999'
git config --global core.editor "nano"
echo "Done."

# Done!
echo -e "\nALL DONE. Now sync sauces & start baking!"
echo -e "Please relogin or run \`source ~/$sh_rc && source ~/.profile\` for environment changes to take effect."

# Go back to original dir
cd "$orig_dir"
