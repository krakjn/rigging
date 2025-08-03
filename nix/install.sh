#!/usr/bin/env bash
set -e

# Output styling
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 5)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
RESET=$(tput sgr0)

# Verify NixOS
if ! grep -iq nixos /etc/os-release; then
  echo "$ERROR This is not NixOS or the distribution information is not available."
  exit 1
else
  echo "$OK Verified NixOS."
fi

# Check Git installation
if ! command -v git &> /dev/null; then
  echo "$ERROR Git is not installed. Run 'nix-shell -p git' to install it."
  exit 1
else
  echo "$OK Git is installed."
fi

REPO_DIR=$(git rev-parse --show-toplevel)

# Check for VM environment
if hostnamectl | grep -q 'Chassis: vm'; then
  sed -i '/vm\.guest-services\.enable = false;/s/false;/true;/' hosts/default/config.nix
  echo "$NOTE VM guest services enabled."
fi

# Check for Nvidia GPU
if command -v lspci &> /dev/null; then
  if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq nvidia; then
    sed -i '/drivers\.nvidia\.enable = false;/s/false;/true;/' hosts/default/config.nix
    echo "$NOTE Nvidia GPU detected and enabled."
  fi
fi

# Prompt for hostname
read -rp "$CAT Enter Your New Hostname: [default] " hostName
if [ -z "$hostName" ]; then
  hostName="default"
fi

if [ "$hostName" != "default" ]; then
  mkdir -p hosts/"$hostName"
  cp hosts/default/*.nix hosts/"$hostName"
  git add .
fi

# Prompt for keyboard layout
read -rp "$CAT Enter your keyboard layout: [us] " keyboardLayout
if [ -z "$keyboardLayout" ]; then
  keyboardLayout="us"
fi
sed -i "s/keyboardLayout = .*/keyboardLayout = \"$keyboardLayout\";/" "./hosts/$hostName/variables.nix"

# Set username and host
installusername="${USER}"
sed -i "s/username = .*/username = \"$installusername\";/" ./flake.nix
sed -i "s/host = .*/host = \"$hostName\";/" ./flake.nix

# Generate hardware configuration
hardware_file="./hosts/$hostName/hardware.nix"
attempts=0
max_attempts=3

while [ $attempts -lt $max_attempts ]; do
  if sudo nixos-generate-config --show-hardware-config > "$hardware_file"; then
    echo "$OK Hardware configuration generated."
    break
  else
    attempts=$((attempts + 1))
    echo "$WARN Attempt $attempts failed; retrying..."
  fi

  if [ $attempts -eq $max_attempts ]; then
    echo "$ERROR Hardware config failed after $max_attempts attempts."
    exit 1
  fi
done

# Configure Git
git config --global user.name "installer"
git config --global user.email "installer@gmail.com"
git add .

# Rebuild NixOS
echo "$NOTE Rebuilding NixOS..."
NIX_CONFIG="experimental-features = nix-command flakes"
sudo "$NIX_CONFIG" nixos-rebuild switch --flake "${REPO_DIR}/#${hostName}"

# Zsh and GTK theme setup
if [ -f "$HOME/.zshrc" ]; then
  cp -b "$HOME/.zshrc" "$HOME/.zshrc-backup"
fi
cp -r assets/.zshrc ~/

# Install GTK themes and icons
echo "Installing GTK-Themes and Icons..."
if [ -d "GTK-themes-icons" ]; then
  rm -rf "GTK-themes-icons"
fi

if git clone --depth 1 https://github.com/JaKooLit/GTK-themes-icons.git; then
  cd GTK-themes-icons
  chmod +x auto-extract.sh
  ./auto-extract.sh
  cd ..
  echo "$OK GTK themes and icons installed."
else
  echo "$ERROR Failed to download GTK themes and icons."
fi

# Copy configurations
for DIR in gtk-3.0 Thunar xfce4; do
  if [ ! -d ~/.config/$DIR ]; then
    cp -r assets/$DIR ~/.config/
    echo "$OK Copied $DIR config."
  else
    echo "$NOTE Config for $DIR already exists."
  fi
done

# Clean up GTK themes and icons
if [ -d "GTK-themes-icons" ]; then
  rm -rf "GTK-themes-icons"
fi

# Download Hyprland-Dots
if [ -d ~/Hyprland-Dots ]; then
  cd ~/Hyprland-Dots
  git stash
  git pull
  git stash apply
else
  if git clone --depth 1 https://github.com/JaKooLit/Hyprland-Dots ~/Hyprland-Dots; then
    cd ~/Hyprland-Dots
  else
    echo "$ERROR Failed to clone Hyprland-Dots."
    exit 1
  fi
fi
chmod +x copy.sh && ./copy.sh

cd "${REPO_DIR}"

cp -r assets/fastfetch ~/.config/ || true

if command -v Hyprland &> /dev/null; then
  echo "$OK Installation completed. Reboot recommended."
  read -rp "$CAT Reboot now? (y/n): " REBOOT
  if [[ "$REBOOT" =~ ^[Yy]$ ]]; then
    systemctl reboot
  else
    echo "Reboot skipped."
  fi
else
  echo "$WARN Hyprland not installed successfully. Check logs."
  exit 1
fi
