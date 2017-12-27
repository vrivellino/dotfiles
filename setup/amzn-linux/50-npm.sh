#!/usr/bin/env bash
set -ex

# only install npm if we're setting up a dev environment
[ "$dev_install" = 'true' ] || exit 0

node_cmd="$(which node)"
sudo "$node_cmd" /usr/local/bin/npm install -g gulp
sudo "$node_cmd" /usr/local/bin/npm install -g jslint
sudo "$node_cmd" /usr/local/bin/npm install -g jsonlint
sudo "$node_cmd" /usr/local/bin/npm install -g jshint

cd

if [ ! -h .jshintrc ] && [ -e .jshintrc ]; then
    mv .jshintrc .jshintrc.pre-vr
fi
ln -snf .dotfiles/.jshintrc .jshintrc
