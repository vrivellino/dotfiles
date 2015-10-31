#!/usr/bin/env bash
set -ex

if [ ! -e ~/.gitconfig ]; then
  set +x
  echo
  read -p 'Enter your name for git config> ' full_name
  read -p 'Enter your email address for git config> ' email

  set -x
  git config --global user.name "$full_name"
  git config --global user.email "$email"
fi

git config --global color.ui auto
git config --global core.editor vim
git config --global core.excludesfile ~/.dotfiles/.gitignore_global
git config --global push.default simple
git config --global log.decorate short
