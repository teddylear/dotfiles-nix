{
  description = "Example kickstart Nix development setup.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    # For neovim
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    darwin = {
      inputs.nixpkgs.follows = "nixpkgs";
      # TODO: Is this required?
      url = "github:LnL7/nix-darwin/nix-darwin-26.05";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hunk = {
      # v0.12.1
      url = "github:modem-dev/hunk?rev=cef118e21d5b6e325732b45464b1d0743e320011";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lumen = {
      # v2.28.0
      url = "github:jnsahaj/lumen?rev=91aa6acb93842f0e72e1a9d5ea20d64813bbbadd";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    herdr = {
      url = "github:ogulcancelik/herdr";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jj = {
      # v0.41.0
      url = "github:jj-vcs/jj?rev=413f539283e5a87f0a2c64dec54a5258a1bee78f";
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
        machineName = "personal-laptop-old";
        git-username = "teddylear";
        git-email = "20077627+teddylear@users.noreply.github.com";
      };

      personal-laptop = darwin-system {
        system = "aarch64-darwin";
        username = "teddylear";
        machineName = "personal-laptop";
        git-username = "teddylear";
        git-email = "20077627+teddylear@users.noreply.github.com";
      };

      business-laptop = darwin-system {
        system = "aarch64-darwin";
        username = "klear";
        machineName = "business-laptop";
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
