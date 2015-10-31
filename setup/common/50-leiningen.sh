#!/usr/bin/env bash
set -ex

# only install rvm if we're setting up a dev environment
[ "$dev_install" = 'true' ] || exit

if [ -e ~/.lein ] && ! [ -h ~/.lein ]; then
  mv ~/.lein ~/.lein.pre-vr
fi

cd
ln -snf .dotfiles/.lein .lein

curl -o ~/bin/lein https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
chmod +x ~/bin/lein
yes | ~/bin/lein upgrade
