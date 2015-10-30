#!/usr/bin/env bash
set -ex

# only install rvm if we're setting up a dev environment
if [ "$1" != 'dev' ]; then
  exit
fi

# pip came from homebrew, shouldn't need sudo
if [ "$(uname -s)" == 'Darwin' ]; then
  pip install --upgrade virtualenv
  exit
fi

## if we're on Amazon, we'll need to sudo pip install these
#if [ "$(uname -s)" == 'Linux' ] || grep -q 'Amazon Linux' /etc/system-release; then
#  exit
#fi

