#!/usr/bin/env bash

set -euo pipefail

kandji_installed() {
  which kandji 1>/dev/null 2>&1 \
    || echo "Kandji cli tool isn't installed. Device may not be enrolled."
}

xcode_tools_installed() {
  pkgutil --pkg-info=com.apple.pkg.CLTools_Executables 1>/dev/null 2>&1 \
    || echo "Xcode tools is not installed. Run xcode-select --install."
}

brew_installed() {
  brew --version 1>/dev/null 2>&1 \
    || echo "Brew is not installed. Kandji Liftoff may not have run yet."
}

gh_installed(){
  gh --version 1>/dev/null 2>&1 \
    || echo "Github CLI Tools is not installed"
}

gh_authenticated() {
  gh auth status 1>/dev/null 2>&1 \
    || echo "Not authenticated with Github CLI Tools"
}

if kandji_installed && xcode_tools_installed && brew_installed; then

  if ! gh_installed; then
    echo "Installing Github CLI Tools."
    brew install gh
  fi

  if ! gh_authenticated; then
    echo "Setting you up on github."
    gh auth login -p ssh -h github.com --insecure-storage -w
  fi

  if [[ ! -d ~/Blake/bx ]]; then
    echo "Cloning bx repo."
    gh repo clone blake-education/bx ~/Blake/bx
  fi

  echo "Starting mac-bootstrap."
  exec ~/Blake/bx/bin/bx mac-bootstrap

else

  echo "Contact #devops and let us know where you're having issues."
  exit 1

fi
