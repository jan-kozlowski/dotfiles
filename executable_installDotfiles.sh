#!/usr/bin/bash
set -euo pipefail

# install yay
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git ~/yay && cd ~/yay && makepkg -si && cd && rm -rf yay

# pacman packages
sudo pacman -S zed obsidian chezmoi starship fastfetch bat chafa zoxide

# AUR packages
yay -S zen-browser-bin

mkdir ~/Documents
mkdir ~/Downloads
mkdir ~/Pictures

chezmoi init --apply https://github.com/$GITHUB_USERNAME/dotfiles.git
