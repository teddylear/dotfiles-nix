# Dotfiles powered by nix

Fork of [kickstart.nix](https://github.com/ALT-F4-LLC/kickstart.nix) and heavily inspired by
[ALT-F4's dotfiles](https://github.com/ALT-F4-LLC/dotfiles-nixos)

Right now only have macos working on current computer, have to figure out more for work, etc

## Install with nix

**NOTE**: probably have to restart shell between a lot of the steps

### Macos
- Base developer tools:
```zsh
xcode-select --install
```
- Install homebrew:
```zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
- Follow steps in [original wiki for macos here](/docs/OG_README.md)

## Post nix & friends install:
- [1password ssh agent setup](https://developer.1password.com/docs/ssh/get-started/#step-3-turn-on-the-1password-ssh-agent)
- github cli login:
```zsh
gh auth login
```
This should work post login:
```zsh
gh auth status
```
- `pyenv`, `tfenv`, `pkenv` version installs
- in brave with vimium installed, add this custom keymapping:
```
map gp togglePinTab
```
- final touches with ansible for directories and running some updates on repos...
```zsh
just ansible-final-touches
```

### Macos
- [Docker-desktop install](https://docs.docker.com/desktop/install/mac-install/)
- re-map `caps lock` to `control`
    - system settings -> keyboard -> keyboard shortcuts -> modifier keys
