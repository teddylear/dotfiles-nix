{ pkgs, ... }:

{
  # add home-manager user settings here
  home.packages = with pkgs; [
      git
      ripgrep
      bat
      tmux
      jq
      tree
      luajitPackages.luarocks-nix
      delta
      sd
      neofetch
      mcfly
      zsh
      fd
      gh
      awscli2
  ];
  home.stateVersion = "23.05";
}
