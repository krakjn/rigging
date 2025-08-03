rebuild hostname:
  sudo nixos-rebuild switch --flake .#{{hostname}} --update-input nixpkgs --update-input rust-overlay --commit-lock-file --upgrade --impure

# removes old store paths, and old generations from system nix profile
clean hostname:
  sudo nix-collect-garbage -d
  sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system
  # sudo nixos-rebuild boot --flake .#{{hostname}} --update-input nixpkgs --update-input rust-overlay --commit-lock-file --upgrade --impure
  sudo nixos-rebuild boot --flake .#{{hostname}} --update-input nixpkgs --commit-lock-file --upgrade --impure

build-boot hostname:
  sudo nixos-rebuild boot --flake .#{{hostname}} --update-input nixpkgs --commit-lock-file --upgrade --impure
