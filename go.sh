#!/bin/bash
set -ex

mkdir -m0755 -p ~/bin

cd "$(dirname $0)"

git submodule init
git submodule update

for script in ./setup/*.sh; do
  if [ "$(uname -s)" = 'Darwin' ]; then
    $script dev
  else
    $script "$@"
  fi
done
