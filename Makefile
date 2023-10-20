.PHONY: lock rebuild

lock:
	nix flake update

personal-laptop:
	darwin-rebuild switch --flake ".#personal-laptop"

