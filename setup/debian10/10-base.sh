#!/usr/bin/env bash

# only install dev tools if we're setting up a dev environment
[ "$dev_install" = 'true' ] || exit 0

set -ex

pkglist='gnupg2 python2.7 python3 python-pip python3-pip libreadline-dev tree vim.nox zip unzip nodejs'
pkglist2='gcc make autoconf automake binutils bison flex pkg-config tidy cmake libczmq-dev libffi-dev libyaml-dev libssl-dev python-pygments python3-pygments python-virtualenv python3-virtualenv'

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y $pkglist $pkglist2
