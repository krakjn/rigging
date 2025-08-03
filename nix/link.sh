#!/usr/bin/env bash

CONF_DIR="${HOME}/.config"

# Declare an array with file paths
path_array=(
  "${HOME}/Storm-Waves-Samurai-4K.mp4.background"
  "${HOME}/.nix-channels"
  "${HOME}/.face"
  "${CONF_DIR}/.icons" 
  "${CONF_DIR}/Kvantum"
  "${CONF_DIR}/Thunar"
  "${CONF_DIR}/autostart"
  "${CONF_DIR}/avizo"
  "${CONF_DIR}/bacon"
  "${CONF_DIR}/bat"
  "${CONF_DIR}/bottom"
  "${CONF_DIR}/btop"
  "${CONF_DIR}/cava"
  "${CONF_DIR}/cool-retro-term-style.json"
  "${CONF_DIR}/discord"
  "${CONF_DIR}/dunst"
  "${CONF_DIR}/felix"
  "${CONF_DIR}/fish"
  "${CONF_DIR}/gnome_settings_backup.dconf"
  "${CONF_DIR}/gtk-3.0"
  "${CONF_DIR}/gtk-4.0"
  "${CONF_DIR}/helix"
  "${CONF_DIR}/htop"
  "${CONF_DIR}/hypr"
  "${CONF_DIR}/kitty"
  "${CONF_DIR}/lazygit"
  "${CONF_DIR}/mimeapps.list"
  "${CONF_DIR}/mpv"
  "${CONF_DIR}/neofetch"
  "${CONF_DIR}/nixpkgs"
  "${CONF_DIR}/pavucontrol.ini"
  "${CONF_DIR}/rofi"
  "${CONF_DIR}/starship.toml"
  "${CONF_DIR}/stylus-catppuccin.json"
  "${CONF_DIR}/swappy"
  "${CONF_DIR}/tealdeer"
  "${CONF_DIR}/topgrade.toml"
  "${CONF_DIR}/user-dirs.dirs"
  "${CONF_DIR}/user-dirs.locale"
  "${CONF_DIR}/waybar"
  "${CONF_DIR}/wezterm"
  "${CONF_DIR}/wlogout"
  "${CONF_DIR}/xfce4"
  "${CONF_DIR}/xsettingsd"
  "${CONF_DIR}/zathura"
  "${CONF_DIR}/zellij"
)
base_dest="/etc/nixos/home"

link() {
    local src="$1"
    local dest="${HOME}${src#/etc/nixos/home}" # Remove /etc/nixos/home from path
    local dest_dir=$(dirname "$dest")
    mkdir -p "$dest_dir" 2>/dev/null

    if [[ -f "$dest" ]]; then
        if [[ "$(stat -c %i "$src")" == "$(stat -c %i "$dest")" ]]; then
            echo "File is already correctly hard linked: ${src} to ${dest}"
        else
            echo "Failed to link ${src} to ${dest}: destination file already exists and is not a hard link"
        fi
    elif ln "$src" "$dest" 2>/dev/null; then
        echo "Hard linked ${src} to ${dest}"
    else
        echo "Failed to hard link ${src} to ${dest}: unknown error"
    fi
}

link_directory() {
    local src="$1"
    local dest="${HOME}${src#/etc/nixos/home}" # Remove /etc/nixos/home from path
    mkdir -p "$dest" 2>/dev/null

    for file in "$src"/*; do
        if [[ -f "$file" ]]; then
            link "$file"
        elif [[ -d "$file" ]]; then
            link_directory "$file"
        fi
    done
}

# Iterate over the array and process each item
for src in "${path_array[@]}"; do
    if [[ -d "$src" ]]; then
        echo "Recursively linking directory $src"
        link_directory "$src"
    elif [[ -f "$src" ]]; then
        link "$src"
    else
        echo "Skipping $src, file does not exist"
    fi
done

echo "Hard linking complete"
