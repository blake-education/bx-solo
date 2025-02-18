#!/usr/bin/env bash

set -euo pipefail

kandji_installed() {
  which kandji 1>/dev/null 2>&1
}

xcode_tools_installed() {
  pkgutil --pkg-info=com.apple.pkg.CLTools_Executables 1>/dev/null 2>&1
}

brew_installed() {
  brew --version 1>/dev/null 2>&1
}

if kandji && xcode_tools_installed && brew_installed; then

  echo "Installing Github CLI Tools."
  brew install gh

  echo "Setting you up on github."
  gh auth login -p ssh -h github.com --insecure-storage -w

  if [[ ! -d ~/Blake/bx ]]; then
    echo "Cloning bx repo."
    git clone git@github.com:blake-education/bx.git ~/Blake/bx
  fi

  echo "Starting mac-bootstrap."
  exec ~/Blake/bx/bin/bx mac-bootstrap

else

  if ! kandji_installed; then
    echo "Kandji cli tool isn't installed. Device may not be enrolled. Contact #devops in slack"

  elif ! xcode_tools_installed; then
    echo "Xcode tools is not installed. Run xcode-select --install."

  elif ! brew_installed; then
    echo "Brew is not installed. Kandji Liftoff may not have run yet. Contact #devops in slack"

  fi

fi
