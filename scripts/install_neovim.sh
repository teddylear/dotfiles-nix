#!/usr/bin/env bash

set -euo pipefail

# THIS IS DEPRECATED, BACK TO NIX

# Manually download from https://github.com/neovim/neovim/releases/latest
# Put in ~/Downloads
# Assumes name is nvim-macos-arm64.tar.gz

tar_prefix="nvim-macos-arm64"
tar_name="$tar_prefix.tar.gz"

echo "cd ~/Downloads..."
cd "$HOME/Downloads"

echo "untar bundle $tar_name..."
tar xzf "$tar_name"

echo "Move folder to /usr/local/nvim"
sudo mv "$tar_prefix" /usr/local/nvim

echo "Remove /usr/local/nvim if exists..."
if [ -d /usr/local/nvim ]; then
    echo "It exists! removing..."
    sudo rm -rf /usr/local/nvim
fi

echo "Create symlink"
sudo ln -sf /usr/local/nvim/bin/nvim /usr/local/bin/nvim

echo "Fix quarantine"
sudo xattr -dr com.apple.quarantine /usr/local/nvim

echo "Validate /usr/local/bin/nvim --version"
/usr/local/bin/nvim --version

# Cleanup

echo "Cleaning things up"
rm "$HOME/Downloads/$tar_name"
rm -rf "$HOME/Downloads/$tar_name"


## Remove commands:
# sudo rm -rf /usr/local/nvim
# sudo rm /usr/local/bin/nvim
