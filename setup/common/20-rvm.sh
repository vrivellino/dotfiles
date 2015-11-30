#!/usr/bin/env bash
set -ex

# only install rvm if we're setting up a dev environment
[ "$dev_install" = 'true' ] || exit 0

if [ ! -d ~/.rvm ]; then
  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  \curl -sSL https://get.rvm.io | bash -s stable --ruby --ignore-dotfiles

  # compile ruby from source on OSX
  # http://toadle.me/2015/04/16/fixing-failing-ssl-verification-with-rvm.html
  if [[ $OSTYPE = darwin* ]]; then
    ruby_ver=$(rvm list default | grep -o 'ruby-[0-9.]\+' | cut -f 2 -d -)
    rvm reinstall $ruby_ver --disable-binary
  fi
fi

if ! rvm list | grep jruby-9.0.3.0 > /dev/null; then
  rvm install jruby-9.0.3.0
  rvm use jruby-9.0.3.0
  gem install bundle
fi
if ! rvm list | grep jruby-9.0.4.0 > /dev/null; then
  rvm install jruby-9.0.4.0
  rvm use jruby-9.0.4.0
  gem install bundle
fi
