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

1. Install `nixpkgs` with official script:

```bash
sh <(curl -L https://nixos.org/nix/install)
```

2. Install `nix-darwin` with official steps:

```bash
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer
```

3. Answer the following with `y` to edit your default `configuration.nix` file:

```bash
Would you like to edit the default configuration.nix before starting? [y/n] y
```

4. Add the following to `configuration.nix` to enable `nix-command` and `flakes` features:

```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```
** NOTE** CTRL-O to save in pico

5. Answer the following with `y` to setup `<darwin>` in `nix-channel` (though it won't be used):

```bash
Would you like to manage <darwin> with nix-channel? [y/n] y
```

## Post nix & friends install:
- install rust tools:
```zsh
rustup install stable
rustup component add rust-analyzer
```
- Link multiple programs home directory configs with:
```zsh
just stow
```
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
- [Docker-desktop install](https://docs.docker.com/desktop/install/mac-install/)
- re-map `caps lock` to `control`
    - system settings -> keyboard -> keyboard shortcuts -> modifier keys
