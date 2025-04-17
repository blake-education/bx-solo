#!/usr/bin/env bash

set -euo pipefail

tick="\xE2\x9C\x85"
cross="\xE2\x9D\x8C"

print() {
  echo -e ${@}
}

kandji_installed() {
  which kandji 1>/dev/null 2>&1 \
    && print "$tick Kandji installed." \
    || (print "$cross Kandji not installed. Device may not be enrolled."; return 1)
}

xcode_tools_installed() {
  pkgutil --pkg-info=com.apple.pkg.CLTools_Executables 1>/dev/null 2>&1 \
    && print "$tick Xcode tools installed." \
    || (print "$cross Xcode tools not installed $cross. Run xcode-select --install."; return 1)
}

brew_installed() {
  brew --version 1>/dev/null 2>&1 \
    && print "$tick Brew installed." \
    || (print "$cross Brew not installed. Kandji Liftoff may not have run yet."; return 1)
}

gh_installed(){
  gh --version 1>/dev/null 2>&1 \
    && print "$tick Github CLI Tools installed." \
    || (print "$cross Github CLI Tools not installed."; return 1)
}

gh_authenticated() {
  gh auth status 1>/dev/null 2>&1 \
    && print "$tick Authenticated with Github CLI Tools." \
    || (print "$cross Not authenticated with Github CLI Tools."; return 1)
}

if kandji_installed && xcode_tools_installed && brew_installed; then

  if ! gh_installed; then
    print "Installing Github CLI Tools."
    brew install gh
  fi

  if ! gh_authenticated; then
    print "Setting you up on github."
    gh auth login -p ssh -h github.com --insecure-storage -w
  fi

  if [[ ! -d ~/Blake/bx ]]; then
    print "Cloning bx repo."
    gh repo clone blake-education/bx ~/Blake/bx
  fi

  print "Starting mac-bootstrap."
  exec ~/Blake/bx/bin/bx mac-bootstrap

else

  print "Contact #devops and let us know where you're having issues."
  exit 1

fi
