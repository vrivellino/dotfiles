#!/usr/bin/env bash
set -ex

# disable for now
exit 0

# only install leiningen if we're setting up a dev environment
[ "$dev_install" = 'true' ] || exit 0

if [ -e ~/.lein ] && ! [ -h ~/.lein ]; then
  mv ~/.lein ~/.lein.pre-vr
fi

cd
ln -snf .dotfiles/.lein .lein

curl -o ~/bin/lein https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
chmod +x ~/bin/lein
yes | ~/bin/lein upgrade
