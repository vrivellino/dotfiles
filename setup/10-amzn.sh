#!/usr/bin/env bash

# only run on Amazon Linux
if [ "$1" != 'dev' ] || [ "$(uname -s)" != 'Linux' ] || grep -q -v 'Amazon Linux' /etc/system-release; then
  exit
fi

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
  cd /opt
  sudo tar xzf /tmp/node-v4.2.1-linux-x64.tar.gz
  sudo chown -R root:root /opt/node-v4.2.1-linux-x64
  rm -f /tmp/node-v4.2.1-linux-x64.tar.gz
fi
sudo ln -snf /opt/node-v4.2.1-linux-x64/bin/node /usr/local/bin/node
sudo ln -snf /opt/node-v4.2.1-linux-x64/bin/npm /usr/local/bin/npm

# casper js
if [ ! -d ~/casperjs ]; then
  git clone git://github.com/n1k0/casperjs.git ~/casperjs
fi
cd ~/bin
ln -snf ../casperjs/bin/casperjs casperjs

# packer
if [ ! -d ~/packer-0.8.6 ]; then
  curl -o /tmp/packer.zip https://releases.hashicorp.com/packer/0.8.6/packer_0.8.6_linux_amd64.zip
  mkdir -p ~/packer-0.8.6
  unzip -d ~/packer-0.8.6 /tmp/packer.zip
  rm -f /tmp/packer.zip
fi
cd ~/bin
for f in ~/packer-0.8.6/* ; do
  if [ -f $f -a -x $f ]; then
    ln -snf $f $(basename $f)
  fi
done
