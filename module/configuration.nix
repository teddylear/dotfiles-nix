{
  # add more system settings here
  nix = {
    settings = {
      builders-use-substitutes = true;
      experimental-features = ["nix-command" "flakes"];
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-users = ["@wheel"];
      warn-dirty = false;
    };
    optimise = {
      automatic = true;
    };
  };
  nixpkgs.config.allowUnfree = true;
  programs.fish.enable = true;
}
