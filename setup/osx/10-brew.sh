#!/usr/bin/env bash
set -ex

if ! which brew > /dev/null 2>&1 ; then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  brew update
  brew upgrade
fi

brew install automake bash coreutils git gnu-getopt gnu-sed gnu-tar gpg maven node packer pkg-config qt5 tidy-html5 tree
brew install czmq libffi libyaml pyenv pyqt python python@2
brew tap macvim-dev/macvim
brew install --HEAD macvim-dev/macvim/macvim --with-properly-linked-python2-python3

## Commenting out due to Homebrew warning
## El Capitan (and presumably higher) does not ship openssl headers
#darwinversion=$(echo $OSTYPE | sed 's/^darwin//' | cut -f 1 -d .)
#if [ $darwinversion -ge 15 ]; then
#    brew link openssl --force
#fi
