# this script should be made public (e.g. in a gist), storing here for source control.

set -euo pipefail

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
