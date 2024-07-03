{
  description = "Example kickstart Nix development setup.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    darwin = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:lnl7/nix-darwin";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    darwin,
    home-manager,
    nixpkgs,
    ...
  }: let
    ## START SYSTEMS ###
    darwin-system = import ./system/darwin.nix;
    # nixos-system = import ./system/nixos.nix { inherit inputs username; };
    ## END SYSTEMS ###
  in {
    darwinConfigurations = {
      # darwin-aarch64 = darwin-system "aarch64-darwin";
      # darwin-x86_64 = darwin-system "x86_64-darwin";
      personal-laptop-old = darwin-system {
        inherit inputs;
        system = "x86_64-darwin";
        username = "kennethlear";
        git-username = "teddylear";
        git-email = "20077627+teddylear@users.noreply.github.com";
      };

      personal-laptop = darwin-system {
        inherit inputs;
        system = "aarch64-darwin";
        username = "teddylear";
        git-username = "teddylear";
        git-email = "20077627+teddylear@users.noreply.github.com";
      };

      business-laptop = darwin-system {
        inherit inputs;
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
