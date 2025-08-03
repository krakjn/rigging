{
  description = "Krakjn's config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes";
    nixvim = {
      url = "github:nix-community/nixvim";
      # If using a stable channel you can use `url = "github:nix-community/nixvim/nixos-<version>"`
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, ... }:
    let
      system = "x86_64-linux";
      host = "daedalus";
      username = "tony";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
    in {
      formatter = { x86_64-linux = pkgs.nixpkgs-fmt; };
      nixosConfigurations = {
        "${host}" = nixpkgs.lib.nixosSystem rec {
          specialArgs = {
            inherit system;
            inherit inputs;
            inherit username;
            inherit host;
          };
          modules = [
            ./modules/local-hardware-clock.nix
            inputs.distro-grub-themes.nixosModules.${system}.default
            ./hosts/${host}/hardware.nix
            ./hosts/${host}/boot.nix
            ./hosts/${host}/config.nix
            ./hosts/${host}/editors.nix
            ./hosts/${host}/fetchers.nix
            ./hosts/${host}/fonts.nix
            ./hosts/${host}/graphics.nix
            ./hosts/${host}/greetd.nix
            ./hosts/${host}/networking.nix
            ./hosts/${host}/programs.nix
            ./hosts/${host}/rust.nix
            # ./hosts/${host}/screen.nix
            ./hosts/${host}/users.nix
          ];
        };
      };
    };
}
