#!/bin/bash
#
# Script to setup Fedora 36 Workstation
#
# Usage:
#        ./fedora-workstation.sh
#

cd $HOME

# Enable RPM Fusion
echo -e "Enabling RPM Fusion\n"
sudo dnf install \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Add flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install packages
echo -e "Installing and updating dnf packages ...\n"
sudo dnf install -y -qq \
    android-tools \
    discord \
    gnome-extensions-app.x86_64 \
    gnome-tweaks \
    neofetch \
    nload \
    pavucontrol

function gnome_extensions(){
array=( https://extensions.gnome.org/extension/3193/blur-my-shell/
https://extensions.gnome.org/extension/4422/gnome-clipboard/
https://extensions.gnome.org/extension/8/places-status-indicator/
https://extensions.gnome.org/extension/19/user-themes/ )

for i in "${array[@]}"
do
    EXTENSION_ID=$(curl -s $i | grep -oP 'data-uuid="\K[^"]+')
    VERSION_TAG=$(curl -Lfs "https://extensions.gnome.org/extension-query/?search=$EXTENSION_ID" | jq '.extensions[0] | .shell_version_map | map(.pk) | max')
    wget -O ${EXTENSION_ID}.zip "https://extensions.gnome.org/download-extension/${EXTENSION_ID}.shell-extension.zip?version_tag=$VERSION_TAG"
    gnome-extensions install --force ${EXTENSION_ID}.zip
    if ! gnome-extensions list | grep --quiet ${EXTENSION_ID}; then
        busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s ${EXTENSION_ID}
    fi
    gnome-extensions enable ${EXTENSION_ID}
    rm ${EXTENSION_ID}.zip
done
}
echo -e "\nInstalling gnome-extensions..."
gnome_extensions

# Multimedia plugins
echo -e "\nInstalling multimedia plugins..."
sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
sudo dnf install lame\* --exclude=lame-devel
sudo dnf group upgrade --with-optional Multimedia

# vscode
echo -e "\nInstalling Visual Studio Code..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
cat <<EOF | sudo tee /etc/yum.repos.d/vscode.repo
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
sudo dnf check-update
sudo dnf install code

# pfetch
echo -e "\nInstalling pfetch..."
git clone https://github.com/dylanaraps/pfetch.git
sudo install pfetch/pfetch /usr/local/bin/
ls -l /usr/local/bin/pfetch
rm -rf pfetch

# git-cli
echo -e "\nInstalling git-cli..."
sudo dnf install 'dnf-command(config-manager)'
sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
sudo dnf install gh
echo -e "Done."

# Platform tools
echo -e "\nInstalling Android SDK platform tools..."
wget -q https://dl.google.com/android/repository/platform-tools-latest-linux.zip
unzip -qq platform-tools-latest-linux.zip
rm platform-tools-latest-linux.zip
echo -e "Done."

# Apk tool
echo -e "\nInstalling apktool and JADX..."
mkdir -p bin
wget -q https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.6.0.jar -O bin/apktool.jar
echo 'alias apktool="java -jar $HOME/bin/apktool.jar"' >> .bashrc


echo -e "\nSetting up shell environment..."
if [[ $SHELL = *zsh* ]]; then
sh_rc=".zshrc"
else
sh_rc=".bashrc"
fi

cat <<'EOF' >> $sh_rc
# Upload a file to transfer.sh
transfer() { if [ $# -eq 0 ]; then echo -e "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi
tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi; cat $tmpfile; rm -f $tmpfile; echo; }
# Super-fast repo sync
repofastsync() { time schedtool -B -e ionice -n 0 `which repo` sync -c --force-sync --optimized-fetch --no-tags --no-clone-bundle -j$(nproc --all) "$@"; }
# List lib dependencies of any lib/bin
list_blob_deps() { readelf -d $1 | grep "\(NEEDED\)" | sed -r "s/.*\[(.*)\]/\1/"; }
export TZ='Asia/Kolkata'
export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache
function msg() {
  echo -e "\e[1;32m$1\e[0m"
}
function helptree() {
  if [[ -z $1 && -z $2 ]]; then
    msg "Usage: helptree <tag> <add/pull>"
    return
  fi
  kernel_version="$( cat Makefile | grep VERSION | head -n 1 | sed "s|.*=||1" | sed "s| ||g" )"
  kernel_patchlevel="$( cat Makefile | grep PATCHLEVEL | head -n 1 | sed "s|.*=||1" | sed "s| ||g" )"
  version=$kernel_version.$kernel_patchlevel
  if [[ $version != "4.14" && $version != "5.4" ]]; then
    msg "Kernel $version not supported! Only msm-5.4 and msm-4.14 are supported as of now."
    return
  fi
  if [[ -z $3 ]]; then
    spec=all
  else
    spec=$3
  fi
  if [[ $2 = "add" ]]; then
    tree_status="Adding"
    commit_status="Import from"
  else
    tree_status="Updating"
    commit_status="Merge"
    if [[ $spec = "all" ]]; then
      msg "Merging kernel as of $1.."
      git fetch https://source.codeaurora.org/quic/la/kernel/msm-$version $1
      git merge FETCH_HEAD -m "Merge tag '$1' of msm-$version"
    fi
  fi
  if [[ $spec = "wifi" || $spec = "all" ]]; then
    for i in qcacld-3.0 qca-wifi-host-cmn fw-api; do
      msg "$tree_status $i subtree as of $1..."
      git subtree $2 -P drivers/staging/$i -m "$i: $commit_status tag '$1'" \
        https://source.codeaurora.org/quic/la/platform/vendor/qcom-opensource/wlan/$i $1
    done
  fi
  if [[ $spec = "techpack" || $spec = "all" ]]; then
    msg "$tree_status audio-kernel subtree as of $1..."
    git subtree $2 -P techpack/audio -m "techpack: audio: $commit_status tag '$1'" \
      https://source.codeaurora.org/quic/la/platform/vendor/opensource/audio-kernel $1
    if [[ $version = "5.4" ]]; then
      msg "$tree_status camera-kernel subtree as of $1..."
      git subtree $2 -P techpack/camera -m "techpack: camera: $commit_status tag '$1'" \
        https://source.codeaurora.org/quic/la/platform/vendor/opensource/camera-kernel $1
      msg "$tree_status dataipa subtree as of $1..."
      git subtree $2 -P techpack/dataipa -m "techpack: dataipa: $commit_status tag '$1'" \
        https://source.codeaurora.org/quic/la/platform/vendor/opensource/dataipa $1
      msg "$tree_status datarmnet subtree as of $1..."
      git subtree $2 -P techpack/datarmnet -m "techpack: datarmnet: $commit_status tag '$1'" \
        https://source.codeaurora.org/quic/la/platform/vendor/qcom/opensource/datarmnet $1
      msg "$tree_status datarmnet-ext subtree as of $1..."
      git subtree $2 -P techpack/datarmnet-ext -m "techpack: datarmnet-ext: $commit_status tag '$1'" \
        https://source.codeaurora.org/quic/la/platform/vendor/qcom/opensource/datarmnet-ext $1
      msg "$tree_status display-drivers subtree as of $1..."
      git subtree $2 -P techpack/display -m "techpack: display: $commit_status tag '$1'" \
        https://source.codeaurora.org/quic/la/platform/vendor/opensource/display-drivers $1
      msg "$tree_status video-driver subtree as of $1..."
      git subtree $2 -P techpack/video -m "techpack: video: $commit_status tag '$1'" \
        https://source.codeaurora.org/quic/la/platform/vendor/opensource/video-driver $1
    elif [[ $version = "4.14" ]]; then
      if [[ $2 = "add" ]] || [ -d "techpack/data" ]; then
        msg "$tree_status data-kernel as of $1..."
        git subtree $2 -P techpack/data -m "techpack: data: $commit_status tag '$1'"  \
          https://source.codeaurora.org/quic/la/platform/vendor/qcom-opensource/data-kernel $1
      fi
    fi
  fi
}
function addtree() {
  if [[ -z $1 ]]; then
    msg "Usage: addtree <tag> [optional: spec]"
    return
  fi
  helptree $1 add $2
}
function updatetree() {
  if [[ -z $1 ]]; then
    msg "Usage: updatetree <tag> [optional: spec]"
    return
  fi
  helptree $1 pull $2
}
EOF

# Add android sdk to path
cat <<'EOF' >> .profile
# Add Android SDK platform tools to path
if [ -d "$HOME/platform-tools" ] ; then
    PATH="$HOME/platform-tools:$PATH"
fi
EOF

# Unlimited history file
sed -i 's/HISTSIZE=.*/HISTSIZE=-1/g' $sh_rc
sed -i 's/HISTFILESIZE=.*/HISTFILESIZE=-1/g' $sh_rc

echo -e "Done."

# Configure git
echo -e "\nSetting up Git..."

git config --global user.email "whyredfire@gmail.com"
git config --global user.name "Karan Parashar"
git config --global review.gerrit.pixelexperience.org.username "whyredfire"

git config --global alias.cp 'cherry-pick'
git config --global alias.c 'commit'
git config --global alias.f 'fetch'
git config --global alias.rb 'rebase'
git config --global alias.rs 'reset'
git config --global alias.ck 'checkout'
git config --global credential.helper 'cache --timeout=99999999'
echo "Done."

# xanmod kernel
function xanmod(){
sudo dnf upgrade --refresh -y
sudo dnf copr enable rmnscnce/kernel-xanmod -y
sudo dnf install kernel-xanmod-edge -y
}

read -p "Would you like to install xanmod kernel? [y/n]" choice

if [[ $choice == *"y"* ]]; then
    echo -e "\nInstalling xanmod kernel..."
    xanmod
    echo -e "Reboot your system to perform changes"
elif
    [[ $choice == *"n"* ]]; then
    echo -e "\nExiting"
    exit
else
    echo "Wrong choice selected!"
fi
