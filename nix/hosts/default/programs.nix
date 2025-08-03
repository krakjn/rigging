{ pkgs, ... }:
let
  inherit (import ./variables.nix) keyboardLayout;
  python-packages = pkgs.python3.withPackages (ps:
    with ps; [
      requests
      pyquery # needed for hyprland-dots Weather script
    ]);
in {

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = (with pkgs; [
    # macchina #neofetch alternative in rust
    # mcfly # terminal history
    # skim #fzf better alternative in rust
    # felix-fm
    # gh
    # gitleaks
    # yt-dlp
    (mpv.override { scripts = [ mpvScripts.mpris ]; }) # with tray
    ags
    aria
    baobab
    bash
    bat
    btop
    btrfs-progs
    cava
    chafa
    clang
    # cliphist
    cmake
    cmatrix
    cool-retro-term
    cpufrequtils
    curl
    dioxus-cli
    du-dust
    duf
    eog
    eza
    fastfetch
    fd
    ffmpeg
    figlet
    file-roller
    firefox
    fzf
    gcc14
    git
    git-ignore
    glib # for gsettings to work
    gnome-system-monitor
    gnumake
    go
    gping
    grim
    gsettings-qt
    gtk-engine-murrine # for gtk themes
    helix
    hyprcursor # requires unstable channel
    hypridle # requires unstable channel
    hyprlock
    hyprpaper
    hyprpicker
    imagemagick
    imv
    inxi
    jq
    just
    killall
    kitty
    lazygit
    libappindicator
    libnotify
    libsForQt5.qtstyleplugin-kvantum # kvantum
    license-generator
    lsd
    lsof
    lua
    mdcat
    mold
    monolith
    mosquitto
    mpv
    mpvpaper
    networkmanagerapplet
    nixfmt
    nodePackages_latest.nodejs
    nodePackages_latest.pnpm
    noti
    numbat
    nvtopPackages.full
    nwg-look # requires unstable channel
    openssl # required by Rainbow borders
    ouch
    pamixer
    pandoc
    pass-git-helper
    pavucontrol
    pciutils
    pipes-rs
    playerctl
    polkit_gnome
    procs
    progress
    pyprland
    # qt5ct
    qt6.qtwayland
    qt6Packages.qtstyleplugin-kvantum # kvantum
    qt6ct
    # ranger
    rewrk
    ripgrep
    rofi-wayland
    rsclock
    sd
    slurp
    starship
    swappy
    swaynotificationcenter
    swww
    tealdeer
    tgpt
    tokei
    topgrade
    trash-cli
    tre-command
    trunk
    unzip
    upx
    vim
    viu
    vivaldi
    wallust
    wget
    wl-clipboard
    wlogout
    xdg-user-dirs
    xdg-utils
    xh
    yad
    yazi
    zathura
    zellij
    zig
    zoxide

    #waybar  # if wanted experimental next line
    #(pkgs.waybar.overrideAttrs (oldAttrs: { mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];}))
  ]) ++ [ python-packages ];

  programs = {
    hyprland = {
      enable = true;
      # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland; #hyprland-git
      # portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland; # xdphls
      xwayland.enable = true;
    };

    firefox.enable = true;
    git.enable = true;
    hyprlock.enable = true;
    nm-applet.indicator = true;

    thunar.enable = true; # FIXME: go to dolphin
    waybar.enable = true;
    thunar.plugins = with pkgs.xfce; [ exo mousepad thunar-archive-plugin thunar-volman tumbler ];

    virt-manager.enable = true;

    #steam = {
    #  enable = true;
    #  gamescopeSession.enable = true;
    #  remotePlay.openFirewall = true;
    #  dedicatedServer.openFirewall = true;
    #};

    xwayland.enable = true;
    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
