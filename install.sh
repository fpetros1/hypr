#!/bin/bash

# Set $hypr if empty
if [ -z "$hypr" ]; then
    export hypr="$HOME/.config/hypr"
fi

# Set automatic monitor config
echo -n "source = ./monitors.auto.conf" > $hypr/hypr-modules/monitors.conf

# Load Environment config in bash/zsh
SOURCE_COMMAND='source "$hypr/.environment"'

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

add_config_folder "$HOME/.config/nvim"
add_config_folder "$HOME/.config/kitty"
add_config_folder "$HOME/.config/xdg-desktop-portal"
add_config_folder "$HOME/.config/lf"

OLDIFS="$IFS"
IFS=":"
for cf in $CONFIGS; do
    if [ -d "$cf" ] || [ -f "$cf" ]; then
        echo "Removing current link: $hypr/$(basename "$cf")"
        rm -Rf "$cf"
    fi
    
    echo "Creating new link for: $hypr/$(basename "$cf")"
    ln -s "$hypr/$(basename "$cf")" "$cf"
done
IFS="$OLDIFS"

