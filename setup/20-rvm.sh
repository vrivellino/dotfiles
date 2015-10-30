#!/usr/bin/env bash
set -ex

# only install rvm if we're setting up a dev environment
if [ "$1" != 'dev' ]; then
  exit
fi

if [ ! -d ~/.rvm ]; then
  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  \curl -sSL https://get.rvm.io | bash -s stable --ruby --ignore-dotfiles
fi
