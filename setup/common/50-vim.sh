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

# only setup vim modules if we're dev
if [ "$1" = 'dev' ]; then
  ln -snf ~/.dotfiles/vim/bundle ~/.vim/bundle
fi

ln -snf ~/.dotfiles/.vimrc ~/.vimrc
