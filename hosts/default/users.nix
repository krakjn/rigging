{ pkgs, username, ... }:

let inherit (import ./variables.nix) gitUsername;
in {
  users = {
    # FIXME: figure out what this means
    # mutableUsers = true;
    users."${username}" = {
      # homeMode = "755";
      isNormalUser = true;
      description = "${gitUsername}";
      extraGroups = [ "networkmanager" "wheel" "libvirtd" "scanner" "lp" "video" "input" "audio" ];

      # define user packages here
      packages = with pkgs; [
        spotify
        discord
        tdesktop
        (vscode-with-extensions.override {
          vscode = vscodium;
          vscodeExtensions = with vscode-extensions;
            [
              asvetliakov.vscode-neovim
              bbenoist.nix
              ms-python.python
              rust-lang.rust-analyzer
              ms-azuretools.vscode-docker
            ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
              name = "everforest";
              publisher = "sainnhe";
              version = "0.3.0";
              sha256 = "9d98abcd5bccd7ad194e904b4e298bd97df9b081b2e63d8b40ea24edad9873b5";
            }];
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
    # FIXME: need to move to fish
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      promptInit = ''
                        fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc
                        HISTFILE=~/.zsh_history;
                        HISTSIZE=10000;
                        SAVEHIST=10000;
                        setopt appendhistory;
        		bindkey -v
                	eval "$(starship init zsh)"
                	eval "$(zoxide init zsh)"
      '';
    };
  };
}
