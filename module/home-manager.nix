{ pkgs, ... }:

{
  # add home-manager user settings here
  home.packages = with pkgs; [ git neovim ripgrep ];
  home.stateVersion = "23.05";
}
