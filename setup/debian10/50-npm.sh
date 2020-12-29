#!/usr/bin/env bash
set -ex

if ! type npm 2>&1; then
    echo "Don't see npm, skipping npm modules..."
    exit 0
fi

cd

mkdir -p ~/.npm-packages
npm config set prefix ~/.npm-packages

npm install -g jslint
npm install -g jsonlint
npm install -g jshint

if [ ! -h .jshintrc ] && [ -e .jshintrc ]; then
    mv .jshintrc .jshintrc.pre-vr
fi
