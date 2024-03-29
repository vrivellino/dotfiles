#!/usr/bin/env bash
set -ex

if [ ! -e ~/.gitconfig ]; then
  set +x
  echo
  read -p 'Enter your name for git config> ' full_name
  read -p 'Enter your email address for git config> ' email
  read -p 'Enter path to your ssh key for commit signing> ' ssh_key

  set -x
  git config --global user.name "$full_name"
  git config --global user.email "$email"
fi

git config --global color.ui auto
git config --global core.editor vim
git config --global core.excludesfile ~/.dotfiles/.gitignore_global
git config --global push.default upstream
git config --global push.autosetupremote true
git config --global log.decorate short
git config --global init.defaultBranch main
#git config --global --add --bool push.autoSetupRemote true

if [[ -s $ssh_key ]]; then
    git config --global user.signingkey "$ssh_key"
    git config --global gpg.format ssh
    git config --global commit.gpgsign true
fi
