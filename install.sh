#!/bin/bash

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

