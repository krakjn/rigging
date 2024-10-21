# Krakjn's Rigging
As someone who deals with build systems all day, a declarative approach to my entire setup is what I gravitate to. Naturally, I fell in love with `nix`. The expressiveness, the control, I can never go back. KDE is too good to ignore, but Hyprland is my daily drive. 

## 🔧 Components

| Component             | Version/Name                |
|-----------------------|-----------------------------|
| Distro                | NixOS                       |
| Kernel                | LTS                         |
| Shell                 | Zsh                         |
| Display Server        | Wayland                     |
| WM (Compositor)       | Hyprland                    |
| Bar                   | Waybar                      |
| Notification          | Dunst                       |
| Launcher              | Rofi-Wayland                |
| Editor                | Neovim, Helix, Codium       |
| Terminal              | Kitty + Starship            |
| OSD                   | Avizo                       |
| Night Gamma           | Wlsunset                    |
| Fetch Utility         | Neofetch                    |
| Theme                 | Catppuccin Macchiato        |
| Icons                 | Colloid-teal-dark, Numix-Circle |
| Font                  | Hack Nerd Font              |
| Player                | Spotify                     |
| File Browser          | Thunar + Yazi               |
| Internet Browser      | Vivaldi, Firefox            |
<!-- | Mimetypes             | MPV, Imv, Zathura           | -->
<!-- | Image Editor          | Swappy                      | -->
| Screenshot            | Grim + Slurp                |
| Recorder              | Wl-screenrec                |
| Color Picker          | Hyprpicker                  |
| Clipboard             | Wl-clipboard + Cliphist + Wl-clip-persist    |
| Idle                  | Hypridle                    |
| Lock                  | Hyprlock                    |
| Logout menu           | Wlogout                     |
| Wallpaper             | Hyprpaper                   |
| Graphical Boot        | Plymouth + Catppuccin-plymouth |
| Display Manager       | Greetd + Tuigreet           |
| Containerization      | Podman                      |


#### 🪧🪧🪧 ANNOUNCEMENT 🪧🪧🪧
- This Repo does not contain Hyprland Dots or configs! Configs are NOT written in Nix. Hyprland Dotfiles will be downloaded from [`KooL's Hyprland-Dots`](https://github.com/JaKooLit/Hyprland-Dots) . 

- Hyprland-Dots use are constantly evolving / improving. you can check CHANGELOGS here [`Hyprland-Dots-Changelogs`](https://github.com/JaKooLit/Hyprland-Dots/wiki/Changelogs) 

- GTK Themes and Icons will be pulled from [`LINK`](https://github.com/JaKooLit/GTK-themes-icons) including Bibata Cursor Modern Ice

- the wallpaper offered to be downloaded towards the end are from this [`REPO`](https://github.com/JaKooLit/Wallpaper-Bank)

> [!IMPORTANT]
> take note of the requirements

### 👋 👋 👋 Requirements 
- You must be running on NixOS.
- Minimum space is 40gb. 60gb recommended as NixOS is a space hungry distro
- Must have installed NIXOS using GPT & UEFI. Systemd-boot is configured as default bootloader, for GRUB users, you need to edit `hosts/default/config.nix` before installing
- Manually edit your host specific files. The host is the specific computer your installing on.


#### 🖥️ Multi Host & User Configuration
- You can now define separate settings for different host machines and users!
- Easily specify extra packages for your users in the users.nix file.
- Easy to understand file structure and simple, but encompassing, configuratiion.


#### 📦 How To Install Packages?
- You can search the [Nix Packages](https://search.nixos.org/packages?) & [Options](https://search.nixos.org/options?) pages for what a package may be named or if it has options available that take care of configuration hurdles you may face.
- Then edit `hosts/<your-hostname>/config.nix` and/or `hosts/<your-hostname>/user.nix` . Config.nix is system-wide changes / packages and user.nix is only available to that user.
- Once you edit, ran `sudo nixos-rebuild switch --flake .#<your-hostname>` NOTE. omit < > and ensure you are in directory where your flake.nix is.

#### 🙋 Having Issues / Questions?
- Please feel free to raise an issue on the repo, please label a feature request with the title beginning with [feature request], thank you!
- If you have a question about KooL's Hyprland dots, see [`KooL's Dots WIKI`](https://github.com/JaKooLit/Hyprland-Dots/wiki) . In that wiki are some tips, keybinds, some collective FAQ etc.


### ⬇️ Installation

- Run this command to ensure git, curl, vim & pciutils (pciutils for nvidia) are installed: Note: or nano if you prefer nano for editing
```
git clone --depth 1 https://github.com/krakjn/rigging.git ~/rigging
cd ~/rigging
nix-shell -p git vim curl pciutils
./install.sh
```

#### Installation Details
- This script will copy `hosts/default` into `hosts/<hostname>` with your prompt answers. 
- If modification is needed, change `hosts/default/*` files
- Edit as required the `config.nix` in `hosts/<your-desired-hostname>/`
- To generate `hardware.nix` run the following:
```
sudo nixos-generate-config --show-hardware-config > hosts/<your-desired-hostname>/hardware.nix
```
- Run this to enable flakes and install the flake replacing hostname with whatever you put as the hostname:
```
NIX_CONFIG="experimental-features = nix-command flakes" 
sudo nixos-rebuild switch --flake .#hostname
```

> Now when you want to rebuild the configuration you have access to an alias called flake-rebuild that will rebuild the flake!

Hope you enjoy! 🎉

#### 💔 known issues 💔 
- GTK themes and Icons including cursor not applied automatically. gsettings does not seem to work
- You can set the GTK Themes, icons and cursor using nwg-look


#### 🪤 My NixOS configs 
- on this repo [`KooL's NIXOS Configs`](https://github.com/JaKooLit/NixOS-configs)


#### ⌨ Keybinds
- Keybinds [`CLICK`](https://github.com/JaKooLit/Hyprland-Dots/wiki/Keybinds)
> [!TIP]
> KooL's Dots v2.3.7 has a searchable keybind function via rofi. (SUPER SHIFT K) or right click the `HINTS` waybar button


#### 🫥 Improving performance for Older Nvidia Cards using driver 470
- [`SEE HERE`](https://github.com/JaKooLit/Hyprland-Dots/discussions/123#discussion-6035205)

### 🔙 Reverting back to your default configs
- if you use flakes, you can just simply locate your default or previous configs. CD into it and execute `sudo nixos-rebuild switch --flake .#<your-previous-flake-hostname>`
- if you dont have flakes enabled previous, simply running `sudo nixos-rebuild switch` will revert you to your default configs from `/etc/nixos/` 
- ⚠️ just remember to clean up your nix/store to remove unnessary garbage from your system `sudo nix-collect-garbage -d`
- OR, simply just revert into your previous snapshot of your system by choosing which snapshot to boot via your bootloaders.

#### 👍👍👍 Thanks and Credits!
- [`Hyprland`](https://hyprland.org/) Of course to Hyprland and @vaxerski for this awesome Dynamic Tiling Manager.
- [`ZaneyOS`](https://gitlab.com/Zaney/zaneyos) - template including auto installation script and idea. ZaneyOS is a NixOS-Hyprland with home-manager. Written in pure nix language
- [`JaKooLit`](https://github.com/JaKooLit) For my springboard into this world.