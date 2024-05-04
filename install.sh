#!/bin/bash

# Set $hypr if empty
if [ -z "$hypr" ]; then
    export hypr="$XDG_CONFIG_HOME/hypr"
fi

# Set automatic monitor config
#echo -n "source = ./monitors.auto.conf" > $hypr/hypr-modules/monitors.conf

# Load Environment config in bash/zsh
#SOURCE_COMMAND='source "$hypr/.environment"'

if [ -f "$HOME/.zshrc" ] && [[ -z $(cat "$HOME/.zshrc" | grep "$SOURCE_COMMAND") ]]; then
    echo -e "\n$SOURCE_COMMAND" | tee -a "$HOME/.zshrc"
fi

if [ -f "$HOME/.bashrc" ] && [[ -z $(cat "$HOME/.bashrc" | grep "$SOURCE_COMMAND") ]]; then
    echo -e "\n$SOURCE_COMMAND" | tee -a "$HOME/.bashrc"
fi

# Create wallpaper config file
cp "$hypr/wallpaper_folders.example.config.txt" "$hypr/wallpaper_folders.config.txt"

# Install Scripts
sudo rm "/usr/bin/update-scripts-link" 2> /dev/null
sudo ln -s $hypr/scripts/update-scripts-link /usr/bin/update-scripts-link
update-scripts-link

# Link Configurations
CONFIGS=""

add_config_folder() {
    CONFIGS=$([ -z "$CONFIGS" ] && echo "$1" || echo "$CONFIGS:$1")
}

link_config_folders() {
    OLDIFS="$IFS"
    IFS=":"
    for cf in $CONFIGS; do
        CF_DIR="$XDG_CONFIG_HOME/$cf"
        if [ -d "$CF_DIR" ] || [ -f "$CF_DIR" ]; then
            echo "Removing current link: $hypr/$cf"
            rm -Rf "$CF_DIR"
        fi
        
        echo "Creating new link for: $hypr/$cf"
        ln -s "$hypr/$(basename "$cf")" "$CF_DIR"
    done
    IFS="$OLDIFS"
}

add_config_folder "MangoHud"
add_config_folder "waybar"
add_config_folder "rofi"
add_config_folder "wofi"
add_config_folder "swaync"
add_config_folder "nvim"
add_config_folder "kitty"
add_config_folder "xdg-desktop-portal"
add_config_folder "lf"

link_config_folders
