#!/usr/bin/env bash
set -ex

cd

if [ ! -h .vim/bundle ] && [ -e .vim/bundle ]; then
  mv .vim/bundle .vim_bundle.pre-vr
fi
if [ ! -h .vimrc ] && [ -e .vimrc ]; then
  mv .vimrc .vimrc.pre-vr
fi

mkdir -p .vim/autoload
ln -snf ~/.dotfiles/vim-pathogen/autoload/pathogen.vim ~/.vim/autoload/pathogen.vim
ln -snf ~/.dotfiles/vim/bundle ~/.vim/bundle
ln -snf ~/.dotfiles/.vimrc ~/.vimrc
