#!/usr/bin/env bash
set -ex

# only install node tools if we're setting up a dev environment
[ "$dev_install" = 'true' ] || exit 0

node_cmd="$(which node)"
sudo "$node_cmd" /usr/local/bin/npm install -g gulp
sudo "$node_cmd" /usr/local/bin/npm install -g jslint
sudo "$node_cmd" /usr/local/bin/npm install -g jsonlint
sudo "$node_cmd" /usr/local/bin/npm install -g jshint
