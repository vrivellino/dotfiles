#!/usr/bin/env bash
set -ex

cd

if [ ! -h .screenrc ] && [ -e .screenrc ]; then
  mv .screenrc .screenrc.pre-vr
fi
ln -snf ~/.dotfiles/.screenrc .screenrc
