#!/bin/bash

# Set $XDG_CONFIG_HOME if empty
[[ -z "$XDG_CONFIG_HOME" ]] && export XDG_CONFIG_HOME="$HOME/.config"

# Set $hypr if empty
[[ -z "$hypr" ]] && export hypr="$XDG_CONFIG_HOME/hypr"

# Setup doas
DOAS_BIN=$(which doas | grep -v "not found")
[[ -z "$DOAS_BIN" ]] && command sudo pacman -S opendoas
command sudo rm /etc/doas.conf
echo "permit persist keepenv setenv {PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin} :wheel"\
    | command sudo tee /etc/doas.conf
echo "" | command sudo tee -a /etc/doas.conf
command sudo chown -c root:root /etc/doas.conf
command sudo chmod -c 0400 /etc/doas.conf

# Install paru if not installed
PARU_BIN=$(which paru | grep -v "not found")

if [[ -z "$PARU_BIN" ]]; then
    doas pacman -S base-devel
    mkdir -p "$HOME/Staging"
    git clone https://aur.archlinux.org/paru-bin.git "$HOME/Staging/paru"
    makepkg -si -p "$HOME/Staging/paru/PKGBUILD"
fi

# Set automatic monitor config
MONITORS_CONFIG_FILE="$hypr/hypr-modules/monitors.conf"
[[ -z $(cat "$MONITORS_CONFIG_FILE" | grep "source = ") ]] && \
    echo -n "source = ./monitors.auto.conf" > "$MONITORS_CONFIG_FILE"

# Load Environment config in bash/zsh
SOURCE_COMMAND='source ".environment"' 

[[ -f "$HOME/.zshrc" ]] && [[ -z $(cat "$HOME/.zshrc" | grep "$SOURCE_COMMAND") ]] && \
    echo -e "\n$SOURCE_COMMAND" | tee -a "$HOME/.zshrc"

[[ -f "$HOME/.bashrc" ]] && [[ -z $(cat "$HOME/.bashrc" | grep "$SOURCE_COMMAND") ]] && \
    echo -e "\n$SOURCE_COMMAND" | tee -a "$HOME/.bashrc"

# Create wallpaper config file
WPP_CONFIG_FILE="$hypr/wallpaper_folders.config.txt"
[[ ! -f "$WPP_CONFIG_FILE" ]] && \
    cp "$hypr/wallpaper_folders.example.config.txt" "$WPP_CONFIG_FILE"

# Install Scripts
doas ln -fs "$hypr/scripts/update-scripts-link" "/usr/bin/update-scripts-link"
update-scripts-link

# Link Configurations

while read CONFIG_FOLDER; do
    ln -sfT "$hypr/config/$CONFIG_FOLDER" "$XDG_CONFIG_HOME/$CONFIG_FOLDER"
done <<< $(ls "$hypr/config")

while read HOME_FILE; do
    ln -fs "$hypr/home/$HOME_FILE" "$HOME/$HOME_FILE"
done <<< $(ls -A $hypr/home)

while read OMZ_CUSTOM_FOLDER; do
    mkdir -p "$HOME/.oh-my-zsh/custom/$OMZ_CUSTOM_FOLDER"
    while read OMZ_CUSTOM_FILE; do
        ln -fs "$hypr/oh-my-zsh/$OMZ_CUSTOM_FOLDER/$OMZ_CUSTOM_FILE" \
            "$HOME/.oh-my-zsh/custom/$OMZ_CUSTOM_FOLDER/$OMZ_CUSTOM_FILE"
    done <<< $(ls $hypr/oh-my-zsh/$OMZ_CUSTOM_FOLDER)
done <<< $(ls $hypr/oh-my-zsh)
