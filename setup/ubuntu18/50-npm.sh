#!/usr/bin/env bash
set -ex

# only install node tools if we're setting up a dev environment
[ "$dev_install" = 'true' ] || exit 0

cd

test -d "${HOME}/.npm-packages" || mkdir "${HOME}/.npm-packages"
npm config set prefix "${HOME}/.npm-packages"

npm install -g jslint
npm install -g jsonlint
npm install -g jshint

if [ ! -h .jshintrc ] && [ -e .jshintrc ]; then
    mv .jshintrc .jshintrc.pre-vr
fi
ln -snf .dotfiles/.jshintrc .jshintrc
