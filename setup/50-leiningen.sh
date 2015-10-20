#!/usr/bin/env bash
set -ex

if [ -e ~/.lein ] && ! [ -h ~/.lein ]; then
  mv ~/.lein ~/.lein.pre-vr
fi
ln -snf .dotfiles/.lein .lein

mkdir -m0755 -p ~/bin
curl -o ~/bin/lein https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
chmod +x ~/bin/lein
yes | ~/bin/lein upgrade
