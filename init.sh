#!/usr/bin/env bash

set -euo pipefail

echo "Installing asdf"
brew install asdf

echo "export PATH=\"\$HOME/.asdf/shims:\$PATH\"" >> $HOME/.zshrc

source $HOME/.zshrc

echo "Installing Github CLI Tools"
asdf plugin add github-cli
asdf install github-cli latest
asdf set --home github-cli latest

echo "Setting you up on github"
gh auth login -p ssh -h github.com --insecure-storage -w

if [[ ! -d ~/Blake/bx ]]; then
  echo "Cloning bx repo"
  git clone git@github.com:blake-education/bx.git ~/Blake/bx
fi

echo "Starting mac-bootstrap"
exec ~/Blake/bx/bin/bx mac-bootstrap
