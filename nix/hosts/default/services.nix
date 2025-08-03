{ ... }: {
  # Services to start
  services = {
    # KDE environment
    # displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;

    xserver = {
      enable = false;
      xkb = {
        layout = "${keyboardLayout}";
        variant = "";
      };
    };

    greetd = {
      enable = true;
      vt = 3;
      settings = {
        default_session = {
          user = username;
          command = ''
            ${pkgs.greetd.tuigreet}/bin/tuigreet \
              --time \
              --time-format '%H:%M | %a=%b[%d]' \
              --greeting 'KDE: startplasma-wayland' \
              --cmd Hyprland
          '';
        };
      };
    };

    smartd = {
      enable = false;
      autodetect = true;
    };

    gvfs.enable = true;
    tumbler.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };

    udev.enable = true;
    envfs.enable = true;
    dbus.enable = true;

    # fstrim = {
    #   enable = true;
    #   interval = "weekly";
    # };

    libinput.enable = true;
    rpcbind.enable = false;
    # flatpak.enable = false;
    blueman.enable = true;
    # hardware.openrgb.enable = true;
    # hardware.openrgb.motherboard = "amd";
    # fwupd.enable = true;
    upower.enable = true;
    gnome.gnome-keyring.enable = true;

    #ipp-usb.enable = true;

    #syncthing = {
    #  enable = false;
    #  user = "${username}";
    #  dataDir = "/home/${username}";
    #  configDir = "/home/${username}/.config/syncthing";
    #};

  };
}
