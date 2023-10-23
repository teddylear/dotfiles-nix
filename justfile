lock:
	nix flake update

personal-laptop:
	darwin-rebuild switch --flake ".#personal-laptop"
