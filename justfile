lock-nix:
	nix flake update

personal-laptop:
	darwin-rebuild switch --flake ".#personal-laptop"

business-laptop:
	darwin-rebuild switch --flake ".#business-laptop"

update-nvim-plugins:
    nvim --headless "+Lazy! sync" +qa

sync-nvim-plugins:
    nvim --headless "+Lazy! restore" +qa
