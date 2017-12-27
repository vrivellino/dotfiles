#!/usr/bin/env bash
set -ex

cd

if [ ! -h .vimrc ] && [ -e .vimrc ]; then
  mv .vimrc .vimrc.pre-vr
fi

mkdir -p .vim/autoload
ln -snf ~/.dotfiles/vim-plug/plug.vim ~/.vim/autoload/plug.vim

ln -snf ~/.dotfiles/.vimrc ~/.vimrc
