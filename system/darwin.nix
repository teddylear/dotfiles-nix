{
  inputs,
  nixpkgs,
  overlays,
  nixpkgs-unstable,
}: {
  system,
  username,
  git-username,
  git-email,
}: let
  system-config = import ../module/configuration.nix;
  home-manager-config = import ../module/home-manager.nix;
  pkgs = import nixpkgs {inherit system;};
  unstablePkgs = import nixpkgs-unstable {inherit system;};
in
  inputs.darwin.lib.darwinSystem {
    inherit system;
    # modules: allows for reusable code
    modules = [
      {
        system.stateVersion = 5;
        services.nix-daemon.enable = true;
        users.users.${username}.home = "/Users/${username}";

        homebrew = {
          enable = true;
          taps = [
            "kwilczynski/homebrew-pkenv"
          ];
          casks = [
            "alacritty"
            "ghostty"
            "1password"
            "brave-browser"
            "caffeine"
            "font-meslo-lg-nerd-font"
            "vlc"
            "nikitabobko/tap/aerospace"
            "spotify"
          ];

          brews = [
            "pyenv"
            "tfenv"
            "pkenv"
            "docker"
          ];
        };
      }
      system-config

      inputs.home-manager.darwinModules.home-manager
      {
        # add home-manager settings here
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users."${username}" = home-manager-config {
          git-email = "${git-email}";
          git-username = "${git-username}";
          unstablePkgs = unstablePkgs;
        };
      }

      {nixpkgs.overlays = overlays;}
    ];
  }
