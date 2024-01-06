{
  description = "Example kickstart Nix development setup.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    darwin = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:lnl7/nix-darwin";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = inputs@{ self, darwin, home-manager, nixpkgs, ... }:
    let
      ## START SYSTEMS ###
      darwin-system = import ./system/darwin.nix;
      overlays = [
        inputs.neovim-nightly-overlay.overlay
      ];
      # nixos-system = import ./system/nixos.nix { inherit inputs username; };
      ## END SYSTEMS ###
    in
    {
      darwinConfigurations = {
        # darwin-aarch64 = darwin-system "aarch64-darwin";
        # darwin-x86_64 = darwin-system "x86_64-darwin";
        personal-laptop = darwin-system {
          inherit inputs;
          inherit overlays;
          system = "x86_64-darwin";
          username = "kennethlear";
          git-username = "teddylear";
          git-email = "20077627+teddylear@users.noreply.github.com";
        };

        business-laptop = darwin-system {
          inherit inputs;
          inherit overlays;
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
