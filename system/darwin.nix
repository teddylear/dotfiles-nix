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
  commonCasks = [
    "ghostty"
    "1password"
    "brave-browser"
    "caffeine"
    "font-jetbrains-mono-nerd-font"
    "nikitabobko/tap/aerospace"
    "spotify"
  ];

  extraCasksForPersonalComp =
    if "${git-username}" == "teddylear"
    then [
      "chatgpt"
      "vlc"
    ]
    else [];
in
  inputs.darwin.lib.darwinSystem {
    inherit system;
    # modules: allows for reusable code
    modules = [
      {
        system.primaryUser = "${username}";
        ids.gids.nixbld = 30000;
        system.stateVersion = 5;
        users.users.${username}.home = "/Users/${username}";

        homebrew = {
          enable = true;
          taps = [
            "kwilczynski/homebrew-pkenv"
            "jnsahaj/lumen"
          ];
          casks = commonCasks ++ extraCasksForPersonalComp;

          brews = [
            "pyenv"
            "tfenv"
            "pkenv"
            "docker"
            "ty"
            "lumen"
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
