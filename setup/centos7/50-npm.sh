#!/usr/bin/env bash
set -ex

# only install node tools if we're setting up a dev environment
[ "$dev_install" = 'true' ] || exit 0

sudo /usr/local/bin/npm install -g gulp
sudo /usr/local/bin/npm install -g jslint
sudo /usr/local/bin/npm install -g jsonlint
sudo /usr/local/bin/npm install -g jshint
