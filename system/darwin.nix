{
  inputs,
  nixpkgs,
  overlays,
}: {
  system,
  username,
  git-username,
  git-email,
}:
# TODO: might bring this back
# system:
let
  system-config = import ../module/configuration.nix;
  home-manager-config = import ../module/home-manager.nix;
in
  inputs.darwin.lib.darwinSystem {
    # inherit system;
    system = "${system}";
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
            "eza"
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
          inputs = inputs;
          git-email = "${git-email}";
          git-username = "${git-username}";
        };
      }
      # add more nix modules here

      {nixpkgs.overlays = overlays;}
    ];
  }
