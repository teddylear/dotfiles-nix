.PHONY: lock rebuild

lock:
	nix flake update

rebuild:
	darwin-rebuild switch --flake ".#darwin-x86_64"

