.PHONY: lock rebuild

lock:
	nix flake lock --update-input nixpkgs --update-input nix

rebuild:
	darwin-rebuild switch --flake ".#darwin-x86_64"

