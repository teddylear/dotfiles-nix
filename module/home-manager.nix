{ pkgs, ... }:

{
  # add home-manager user settings here
  home.packages = with pkgs; [
      # cli tools
      git
      ripgrep
      bat
      tmux
      jq
      tree
      delta
      sd
      neofetch
      mcfly
      zsh
      fd
      gh
      awscli2
      # NOTE: Add eza when it's available
      # eza

      # Lua and Neovim build stuff
      luajitPackages.luarocks-nix
      cmake
      gettext
      ninja


  ];
  home.stateVersion = "23.05";

  programs.go = {
    enable = true;
    goPath = "Development/language/go";
  };
}

