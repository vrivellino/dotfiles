#!/usr/bin/env bash
set -ex

# only install these npm modules if we're setting up a dev environment
if [ "$1" != 'dev' ]; then
  exit
fi

if [ "$(uname -s)" = 'Darwin' ]; then
  npm install -g jsonlint jslint gulp
else
  sudo /usr/local/bin/npm install -g jsonlint jslint gulp
fi
