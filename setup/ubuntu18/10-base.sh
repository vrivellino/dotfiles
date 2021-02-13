#!/usr/bin/env bash

# only install dev tools if we're setting up a dev environment
[ "$dev_install" = 'true' ] || exit 0

set -ex

#. "$(dirname "$0")/../versions"

pkglist='gnupg2 default-jre python3 python3-pip libreadline-dev tree vim-nox zip unzip'
pkglist2='gcc make autoconf automake binutils bison flex pkg-config tidy cmake libczmq-dev libffi-dev libyaml-dev libssl-dev python3-pygments python3-virtualenv'

sudo apt update
sudo apt upgrade -y
sudo apt install -y $pkglist $pkglist2
sudo apt install -y nodejs
sudo apt install -y npm
