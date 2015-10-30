#!/usr/bin/env bash

# only run on Mac
if [ "$(uname -s)" != 'Darwin' ]; then
  exit
fi

set -ex

if ! which brew > /dev/null 2>&1 ; then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  brew update
  brew upgrade
fi

brew install automake bash casperjs coreutils git gnu-getopt gnu-sed gnu-tar gpg maven node packer pkg-config qt5 tidy-html5 tree vim
brew install czmq libffi libyaml pyqt python
