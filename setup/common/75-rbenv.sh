#!/usr/bin/env bash
set -ex

cd

if [ ! -h .rbenv ] && [ -e .rbenv ]; then
  mv .rbenv .rbenv.pre-vr
fi
if pushd ~/.dotfiles/rbenv/plugins > /dev/null; then
  rm -rf ruby-build
  ln -snf ../../ruby-build

  popd > /dev/null
  ln -snf ~/.dotfiles/rbenv .rbenv
fi
