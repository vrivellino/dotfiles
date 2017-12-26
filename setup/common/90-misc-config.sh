#!/usr/bin/env bash
set -ex

cd

test -d .config || mkdir -m 0700 .config
if [ ! -h .config/flake8 ] && [ -e .config/flake8 ]; then
    mv .config/flake8 .config/flake8.pre-vr
fi

ln -snf ~/.dotfiles/config-flake8 .config/flake8
