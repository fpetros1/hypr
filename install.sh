#!/bin/bash

# Install Scripts
sudo ln -s $hypr/scripts/update-scripts-link /usr/bin/update-scripts-link
/usr/bin/update-scripts-link

# Link Configurations
CONFIGS=""

add_config_folder() {
    if [ -z "$CONFIGS" ]; then
        TARGETS="$1"
    else
        CONFIGS="$CONFIGS:$1"
    fi
}

add_config_folder "$HOME/.config/nvim"
add_config_folder "$HOME/.config/kitty"
add_config_folder "$HOME/.config/xdg-desktop-portal"

OLDIFS="$IFS"
IFS=":"
for cf in $CONFIGS; do
    if [ -d "$cf" ] || [ -f "$cf" ]; then
        rm -Rf "$cf"
    fi

    ln -s "$hypr/$(basename "$cf")" "$cf"
done
IFS="$OLDIFS"

