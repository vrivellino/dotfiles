#!/usr/bin/env bash
set -ex

pip install --upgrade virtualenv

## copied from monolithic setup.sh - refactor into linux support
#if ! sudo yum install python-zmq python-pygments openssl-devel libffi-devel; then
#  echo
#  echo 'Tried to install python-zmq, python-pygments, etc. via yum.'
#  echo '<ENTER> to continue if you are sure they are available ...'
#  read junk
#fi

## Don't think this needs to be installed site-wide anymore
## IPython and its dependencies must be installed site-wide
#if [ "$(uname -s)" = 'Darwin' ]; then
#  sudo pip install --upgrade gnureadline
#fi
#sudo pip install --upgrade "ipython[all]"
