{
  description = "Example kickstart Nix development setup.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    # switch back to unstable
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Then use command to get hash and update below when commented out:
    # jq '.nodes."nixpkgs-unstable".locked.rev' < flake.lock
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/46e634be05ce9dc6d4db8e664515ba10b78151ae";

    # Test comment
    darwin = {
      inputs.nixpkgs.follows = "nixpkgs";
      # TODO: Is this required?
      url = "github:LnL7/nix-darwin/nix-darwin-25.05";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zig.url = "github:mitchellh/zig-overlay";
  };

  outputs = inputs @ {
    self,
    darwin,
    home-manager,
    nixpkgs,
    nixpkgs-unstable,
    ...
  }: let
    ## START SYSTEMS ###
    overlays = [
      inputs.zig.overlays.default
    ];
    darwin-system = import ./system/darwin.nix {
      inherit inputs nixpkgs overlays nixpkgs-unstable;
    };
    # nixos-system = import ./system/nixos.nix { inherit inputs username; };
    ## END SYSTEMS ###
  in {
    darwinConfigurations = {
      personal-laptop-old = darwin-system {
        system = "x86_64-darwin";
        username = "kennethlear";
        git-username = "teddylear";
        git-email = "20077627+teddylear@users.noreply.github.com";
      };

      personal-laptop = darwin-system {
        system = "aarch64-darwin";
        username = "teddylear";
        git-username = "teddylear";
        git-email = "20077627+teddylear@users.noreply.github.com";
      };

      business-laptop = darwin-system {
        system = "aarch64-darwin";
        username = "klear";
        git-username = "klear-nasuni";
        git-email = "73537396+klear-nasuni@users.noreply.github.com";
      };
    };

    # Commenting out for now
    # nixosConfigurations = {
    # nixos-aarch64 = nixos-system "aarch64-linux";
    # nixos-x86_64 = nixos-system "x86_64-linux";
    # };
  };
}
