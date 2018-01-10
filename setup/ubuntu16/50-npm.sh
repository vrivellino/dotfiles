#!/usr/bin/env bash
set -ex

# only install npm if we're setting up a dev environment
[ "$dev_install" = 'true' ] || exit 0

sudo npm install -g gulp
sudo npm install -g jslint
sudo npm install -g jsonlint
sudo npm install -g jshint

cd

if [ ! -h .jshintrc ] && [ -e .jshintrc ]; then
    mv .jshintrc .jshintrc.pre-vr
fi
ln -snf .dotfiles/.jshintrc .jshintrc
