#!/usr/bin/env bash
set -ex

# setup dotfiles in home dir
cd

ln -snf .dotfiles/.bashrc .bashrc_vr

if ! grep -q -F 'source ~/.bashrc_vr' ~/.bashrc; then
  echo '[ -f ~/.bashrc_vr ] && source ~/.bashrc_vr' >> ~/.bashrc
fi

if ! grep -q -F 'source ~/.bashrc' ~/.bash_profile; then
  echo '[ -f ~/.bashrc ] && source ~/.bashrc' >> ~/.bash_profile
fi
