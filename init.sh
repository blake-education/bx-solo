# this script should be made public (e.g. in a gist), storing here for source control.

set -euo pipefail

# install Xcode Command Line Tools
install_xcode() {
  if [[ $(xcode-select -p 1>/dev/null;echo $?) != 0 ]]; then
    xcode-select --install
    echo "Installing xcode command line tools. If prompted, click install in the pop up window"
    echo "Press enter once installation is complete"
    read
  else
    echo "Looking for xcode command line tools updates"
    touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
    PROD=$(softwareupdate -l |
    grep "\*.*Command Line" |
    head -n 1 | awk -F"*" '{print $2}' |
    sed -e 's/^ *//' |
    tr -d '\n')
    softwareupdate -i "$PROD" --verbose;
  fi
  return $(xcode-select -p 1>/dev/null;echo $?)
}

if ! install_xcode; then
  echo "xcode cli installation failed, please manually install before continuing"
fi

cat <<EODOC
laptop setup for the greater good and prohax: phase 1
Phase one is all about getting on to github.
<press enter to get going>
EODOC

read
echo "<cracks knuckles> ok then"


if [[ ! -f $HOME/.ssh/id_rsa ]]; then
  echo 'first of all, lets create an ssh key'
  ssh-keygen
else
  echo 'looks like you already have an ssh key. Lets carry on'
fi

echo checking github...
echo '(you should agree to continue connecting if asked)'

test_gh() {
  set +e
  set +o pipefail
  ssh -T git@github.com 2>&1 | grep success
  local rv=$?
  set -e
  set -o pipefail
  return $rv
}

if ! test_gh; then
  cat <<DOC 
Sorry to be the one to tell you, but github ain't setup, bub.
** Protip *******
if you're doing this on behalf of a new starter
temporarily add the key to your github account.
Don't forget to remove it before they add it to their account
when they arrive.)
*****************
Add this key to github
DOC
  cat ~/.ssh/id_rsa.pub
  echo "hit enter to open GitHub ssh key page. Login if necessary"
  echo "return to this window when done..."
  read
  open "https://github.com/settings/ssh/new"
  echo "After you've added you ssh key, hit enter to continue"
  read

cat <<EODOC
Let's see if we can github now...
EODOC

  if ! test_gh; then
    echo "hm, github still failing"
    exit 1
  fi
fi

echo ok, github is a go

cat <<EODOC
** Protip *******
Make sure your account has been added to blake-education's GitHub team.
Contact devops@blake.com.au if you are having issues
*****************
EODOC

mkdir -p ~/Blake

if [[ ! -d ~/Blake/bx ]]; then
  echo "setting up bx"
  git clone git@github.com:blake-education/bx.git ~/Blake/bx
else
  echo bx looking good
fi

exec ~/Blake/bx/bin/bx mac-bootstrap
