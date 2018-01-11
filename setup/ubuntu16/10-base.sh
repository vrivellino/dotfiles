#!/usr/bin/env bash

# only install dev tools if we're setting up a dev environment
[ "$dev_install" = 'true' ] || exit 0

set -ex

. "$(dirname "$0")/../versions"
test -n $maven_ver
test -n $node_ver
test -n $packer_ver

pkglist='gnupg2 openjdk-8-jdk python2.7 python3 python-pip python3-pip libreadline-dev tree vim.nox vim-nox-py2 zip unzip'
pkglist2='gcc make autoconf automake binutils bison flex pkg-config tidy cmake libczmq-dev libffi-dev libyaml-dev libssl-dev python-pygments python3-pygments python-virtualenv python3-virtualenv'

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y $pkglist $pkglist2

# maven
if [ ! -d ~/apache-maven-${maven_ver} ]; then
  curl -o /tmp/apache-maven-keys https://www.apache.org/dist/maven/KEYS
  curl -o /tmp/apache-maven-${maven_ver}-bin.zip.asc https://www.apache.org/dist/maven/maven-3/${maven_ver}/binaries/apache-maven-${maven_ver}-bin.zip.asc
  curl -o /tmp/apache-maven-${maven_ver}-bin.zip http://apache.mirrors.tds.net/maven/maven-3/${maven_ver}/binaries/apache-maven-${maven_ver}-bin.zip
  gpg --import /tmp/apache-maven-keys
  gpg --verify /tmp/apache-maven-${maven_ver}-bin.zip.asc /tmp/apache-maven-${maven_ver}-bin.zip
  unzip -d ~/ /tmp/apache-maven-${maven_ver}-bin.zip
  rm -f /tmp/apache-maven-keys /tmp/apache-maven-${maven_ver}-bin.zip.asc /tmp/apache-maven-${maven_ver}-bin.zip
fi

cd ~/bin
for f in mvn mvnDebug mvnyjp ; do
  ln -snf ~/apache-maven-${maven_ver}/bin/$f $f
done

# nodejs
if [ "$(node --version 2>&1)" != "v${node_ver}" ]; then
  curl -L -o /tmp/node-v${node_ver}-linux-x64.tar.gz https://nodejs.org/dist/v${node_ver}/node-v${node_ver}-linux-x64.tar.gz
  cd /usr/local
  sudo tar --strip-components 1 --owner=root --group=root -xzf /tmp/node-v${node_ver}-linux-x64.tar.gz
  sudo rm -f /tmp/node-v${node_ver}-linux-x64.tar.gz CHANGELOG.md LICENSE README.md
  sudo chown -R root:root .
fi

# packer
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
