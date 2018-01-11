#!/usr/bin/env bash
set -ex

# only install rbenv if we're setting up a dev environment
[ "$dev_install" = 'true' ] || exit 0

cd

if [ ! -h .rbenv ] && [ -e .rbenv ]; then
  mv .rbenv .rbenv.pre-vr
fi

if pushd ~/.dotfiles/rbenv > /dev/null; then
  [ -d plugins ] || mkdir plugins
  cd plugins
  rm -rf ruby-build
  ln -snf ../../ruby-build

  popd > /dev/null
  ln -snf ~/.dotfiles/rbenv .rbenv

  export PATH="$HOME/.rbenv/bin:$PATH"
  type rbenv | command grep -q -F 'rbenv is a function' || eval "$(rbenv init -)"

  rbenv install 2.4.3
  rbenv global 2.4.3

  gem install rake
  gem install bundler
  gem install test-kitchen
fi
