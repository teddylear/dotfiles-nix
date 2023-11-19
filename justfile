lock-nix:
	nix flake update

personal-laptop:
	darwin-rebuild switch --flake ".#personal-laptop"

update-nvim-plugins:
 nvim --headless "+Lazy! sync" +qa
