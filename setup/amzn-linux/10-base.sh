#!/usr/bin/env bash

# only install dev tools if we're setting up a dev environment
[ "$dev_install" = 'true' ] || exit 0

set -ex

# install what we can from yum
sudo yum groupinstall -y 'Development Tools'
sudo yum install -y gnupg java-1.8.0-openjdk pkgconfig python27-pip tree vim-enhanced zip unzip
sudo yum --enablerepo epel install -y tidy czmq czmq-devel libffi libffi-devel libyaml libyaml-devel openssl-devel python27-pygments python27-virtualenv

# maven
if [ ! -d ~/apache-maven-3.3.3 ]; then
  curl -o /tmp/apache-maven-keys http://www.apache.org/dist/maven/KEYS
  curl -o /tmp/apache-maven-3.3.3-bin.zip.asc http://www.apache.org/dist/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.zip.asc
  curl -o /tmp/apache-maven-3.3.3-bin.zip http://apache.mirrors.tds.net/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.zip
  gpg --import /tmp/apache-maven-keys
  gpg --verify /tmp/apache-maven-3.3.3-bin.zip.asc /tmp/apache-maven-3.3.3-bin.zip
  unzip -d ~/ /tmp/apache-maven-3.3.3-bin.zip
  rm -f /tmp/apache-maven-keys /tmp/apache-maven-3.3.3-bin.zip.asc /tmp/apache-maven-3.3.3-bin.zip
fi

cd ~/bin
for f in mvn mvnDebug mvnyjp ; do
  ln -snf ~/apache-maven-3.3.3/bin/$f $f
done

# nodejs
if [ "$(node --version 2>&1)" != 'v4.2.1' ]; then
  curl -L -o /tmp/node-v4.2.1-linux-x64.tar.gz https://nodejs.org/dist/v4.2.1/node-v4.2.1-linux-x64.tar.gz
  cd /usr/local
  sudo tar --strip-components 1 --owner=root --group=root -xzf /tmp/node-v4.2.1-linux-x64.tar.gz
  sudo rm -f /tmp/node-v4.2.1-linux-x64.tar.gz CHANGELOG.md LICENSE README.md
  sudo chown -R root:root .
fi

# casper js
if [ ! -d ~/casperjs ]; then
  git clone git://github.com/n1k0/casperjs.git ~/casperjs
fi
cd ~/bin
ln -snf ../casperjs/bin/casperjs casperjs

# packer
packer_ver='0.10.1'
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
