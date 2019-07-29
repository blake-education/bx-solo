# this script should be made public (e.g. in a gist), storing here for source control.

set -euo pipefail

# install Xcode Command Line Tools
# https://github.com/timsutton/osx-vm-templates/blob/ce8df8a7468faa7c5312444ece1b977c1b2f77a4/scripts/xcode-cli-tools.sh
if [[ $(xcode-select -p 1>/dev/null;echo $?) != 0 ]]; then
  touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
  PROD=$(softwareupdate -l |
    grep "\*.*Command Line" |
    head -n 1 | awk -F"*" '{print $2}' |
    sed -e 's/^ *//' |
    tr -d '\n')
  softwareupdate -i "$PROD" --verbose;
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
  echo 'looks like you already have an ssh key. Let's carry on'
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
Go add this key to github
DOC
  cat ~/.ssh/id_rsa.pub

  echo "hit enter when you're ready"
  read

cat <<EODOC
Let's see if we can github now...
EODOC

  if ! test_gh; then
    echo hm, github still failing
    exit 1
  fi
fi

echo ok, github is a go

cat <<EODOC
** Protip *******
Don't forget to add the new starter's github user to our team.
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
