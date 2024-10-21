{ pkgs, username, ... }:

let
  inherit (import ./variables.nix) gitUsername;
in
{
  users = {
    # FIXME: figure out what this means
    # mutableUsers = true;
    users."${username}" = {
      # homeMode = "755";
      isNormalUser = true;
      description = "${gitUsername}";
      extraGroups = [
        "networkmanager"
        "wheel"
        "libvirtd"
        "scanner"
        "lp"
        "video"
        "input"
        "audio"
      ];

      # define user packages here
      packages = with pkgs; [
        spotify
        discord
        tdesktop
	(vscode-with-extensions.override {
	  vscode = vscodium;
	  vscodeExtensions = with vscode-extensions; [
	    vscodevim.vim
	    bbenoist.nix
	    ms-python.python
	    #ms-azuretools.vscode-docker
	  ];
	})
      ];
    };

    defaultUserShell = pkgs.zsh;
  };

  environment.shells = with pkgs; [ zsh ];

  programs = {
    starship = {
      enable = true;
      settings = { };
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      # ohMyZsh = {
      #   enable = true;
      #   plugins = [ "git" ];
      #   theme = "xiong-chiamiov-plus";
      # };

      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      promptInit = ''
        fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc
        HISTFILE=~/.zsh_history;
        HISTSIZE=10000;
        SAVEHIST=10000;
        setopt appendhistory;
	eval "$(starship init zsh)"
      '';
    };
  };
}
