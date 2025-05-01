#!/usr/bin/env bash

set -euo pipefail

tick="\xE2\x9C\x85"
cross="\xE2\x9D\x8C"
finger="\xF0\x9F\x91\x89"

success() {
  echo -e "$tick ${@}"
}

notify() {
  echo -e "$finger ${@}"
}

error() {
  echo -e "$cross ${@}"; return 1
}

kandji_installed() {
  which kandji 1>/dev/null 2>&1 \
    && success "Kandji installed." \
    || error "Kandji not installed. Device may not be enrolled."
}

xcode_tools_installed() {
  pkgutil --pkg-info=com.apple.pkg.CLTools_Executables 1>/dev/null 2>&1 \
    && success "Xcode tools installed." \
    || error "Xcode tools not installed. Run xcode-select --install."
}

brew_installed() {
  brew --version 1>/dev/null 2>&1 \
    && success "Brew installed." \
    || error "Brew not installed. Kandji Liftoff may not have run yet."
}

gh_installed(){
  gh --version 1>/dev/null 2>&1 \
    && success "Github CLI Tools installed." \
    || error "Github CLI Tools not installed."
}

gh_authenticated() {
  gh auth status 1>/dev/null 2>&1 \
    && success "Authenticated with Github CLI Tools." \
    || error "Not authenticated with Github CLI Tools."
}

if kandji_installed && xcode_tools_installed && brew_installed; then

  if ! gh_installed; then
    notify "Installing Github CLI Tools."
    brew install gh
  fi

  if ! gh_authenticated; then
    notify "Setting you up on github."
    gh auth login -p ssh -h github.com --insecure-storage -w
  fi

  if [[ ! -d ~/Blake/bx ]]; then
    notify "Cloning bx repo."
    gh repo clone blake-education/bx ~/Blake/bx
  fi

  if [[ ! -f ~/.bx-solo-run ]]; then
    notify "Creating ~/.bx-solo-run file"
    echo $(date "+%Y-%m-%d %H:%M:%S") >> ~/.bx-solo-run
  fi

  notify "Starting mac-bootstrap."
  exec ~/Blake/bx/bin/bx mac-bootstrap

else

  error "Contact #devops and let us know where you're having issues."

fi
