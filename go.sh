#!/bin/bash
set -ex

cd "$(dirname $0)"

git submodule init
git submodule update

for script in ./setup/*.sh; do
  $script
done
