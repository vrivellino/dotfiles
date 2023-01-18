#!/usr/bin/env bash
set -ex

cd

test -d .config || mkdir -m 0700 .config
if [ ! -h .config/flake8 ] && [ -e .config/flake8 ]; then
    mv .config/flake8 .config/flake8.pre-vr
fi
ln -snf ~/.dotfiles/config-flake8 .config/flake8

if [ ! -h .config/yamllint ] && [ -e .config/yamllint ]; then
    mv .config/yamllint .config/yamllint.pre-vr
fi
ln -snf ~/.dotfiles/config-yamllint .config/yamllint

if [ ! -h .rubocop.yml ] && [ -e .rubocop.yml ]; then
    mv .rubocop.yml .rubocop.yml.pre-vr
fi
ln -snf ~/.dotfiles/.rubocop.yml .rubocop.yml

# finish vim
if [[ $OSTYPE =~ darwin ]]; then
    mvim -c PlugInstall
else
    vim -c PlugInstall
fi
