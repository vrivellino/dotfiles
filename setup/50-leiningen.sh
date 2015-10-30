#!/usr/bin/env bash
set -ex

# only install leiningen if we're setting up a dev environment
if [ "$1" != 'dev' ]; then
  exit
fi

if [ -e ~/.lein ] && ! [ -h ~/.lein ]; then
  mv ~/.lein ~/.lein.pre-vr
fi
ln -snf .dotfiles/.lein .lein

curl -o ~/bin/lein https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
chmod +x ~/bin/lein
yes | ~/bin/lein upgrade
