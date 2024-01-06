fmt:
    stylua nvim/.config/nvim/
    nixpkgs-fmt module/
    nixpkgs-fmt system/
    nixpkgs-fmt flake.nix

update-nix:
	nix flake update

personal-laptop:
	darwin-rebuild switch --flake ".#personal-laptop"

business-laptop:
	darwin-rebuild switch --flake ".#business-laptop"

ansible-final-touches:
    @echo "==> Running ansible..."
    ANSIBLE_NOCOWS=1 ansible-playbook ansible/local.yml

update-nvim-plugins: ansible-final-touches
    @echo "==> Running update on nvim plugins..."
    nvim --headless "+Lazy! sync" +qa

sync-nvim-plugins: ansible-final-touches
    @echo "==> Running sync on  nvim plugins..."
    nvim --headless "+Lazy! restore" +qa

ubuntu-update:
    @echo "==> Ubuntu update..."
    sudo apt update
    sudo apt upgrade
    sudo apt autoremove

nvim-stow:
    stow -R nvim
