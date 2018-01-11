#!/usr/bin/env bash
set -ex

npm install -g jslint
npm install -g jsonlint
npm install -g jshint

cd

if [ ! -h .jshintrc ] && [ -e .jshintrc ]; then
    mv .jshintrc .jshintrc.pre-vr
fi
ln -snf .dotfiles/.jshintrc .jshintrc
