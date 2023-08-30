#!/usr/bin/env bash
#
# Script to setup asusctl and nvidia drivers on my machine
# Supported OS: Fedora 38
#
# Usage: ./asusctl.sh
#

sudo dnf copr enable lukenukem/asus-linux

sudo dnf update -y
sudo dnf install kernel-devel
sudo dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda

sudo systemctl enable nvidia-hibernate.service nvidia-suspend.service nvidia-resume.service --now
# TODO: Update system boot configuration

sudo dnf install asusctl supergfxctl
sudo dnf update --refresh
sudo systemctl enable supergfxd.service --now
