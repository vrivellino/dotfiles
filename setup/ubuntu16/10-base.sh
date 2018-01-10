#!/usr/bin/env bash

# only install dev tools if we're setting up a dev environment
[ "$dev_install" = 'true' ] || exit 0

set -ex

pkglist='gnupg2 openjdk-8-jdk python2.7 python3 python-pip python3-pip libreadline-dev tree vim.nox vim-nox-py2 zip unzip'
pkglist2='gcc make autoconf automake binutils bison flex pkg-config tidy cmake libczmq-dev libffi-dev libyaml-dev libssl-dev python-pygments python3-pygments python-virtualenv python3-virtualenv'
pkglist3='maven npm'

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y $pkglist $pkglist2 $pkglist3

# casper js
if [ ! -d ~/casperjs ]; then
  git clone git://github.com/n1k0/casperjs.git ~/casperjs
fi
cd ~/bin
ln -snf ../casperjs/bin/casperjs casperjs

# packer
packer_ver='1.1.3'
if [ ! -d ~/packer-${packer_ver} ]; then
  curl -o /tmp/packer.zip https://releases.hashicorp.com/packer/${packer_ver}/packer_${packer_ver}_linux_amd64.zip
  mkdir -p ~/packer-${packer_ver}
  unzip -d ~/packer-${packer_ver} /tmp/packer.zip
  rm -f /tmp/packer.zip
fi
cd ~/bin
for f in ~/packer-${packer_ver}/* ; do
  if [ -f $f -a -x $f ]; then
    ln -snf $f $(basename $f)
  fi
done
