#!/usr/bin/env bash

# only install dev tools if we're setting up a dev environment
[ "$dev_install" = 'true' ] || exit 0

set -ex

# install what we can from yum
sudo yum groupinstall -y 'Development Tools'
sudo yum install -y gnupg java-1.8.0-openjdk pkgconfig screen tree vim-enhanced zip unzip

# enable epel repo and install packages from it
if [ ! -f /etc/yum.repos.d/epel.repo ]; then
  sudo rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
fi
sudo yum install -y tidy czmq czmq-devel libffi libffi-devel libyaml libyaml-devel openssl-devel python-pip python-pygments python-virtualenv

# maven
maven_ver='3.5.0'
if [ ! -d ~/apache-maven-${maven_ver} ]; then
  curl -o /tmp/apache-maven-keys https://www.apache.org/dist/maven/KEYS
  curl -o /tmp/apache-maven-${maven_ver}-bin.zip.asc https://www.apache.org/dist/maven/maven-3/${maven_ver}/binaries/apache-maven-${maven_ver}-bin.zip.asc
  curl -o /tmp/apache-maven-${maven_ver}-bin.zip https://apache.mirrors.tds.net/maven/maven-3/${maven_ver}/binaries/apache-maven-${maven_ver}-bin.zip
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
node_ver='6.10.3'
if [ "$(node --version 2>&1)" != "v${node_ver}" ]; then
  curl -L -o /tmp/node-v${node_ver}-linux-x64.tar.gz https://nodejs.org/dist/v${node_ver}/node-v${node_ver}-linux-x64.tar.gz
  cd /usr/local
  sudo tar --strip-components 1 --owner=root --group=root -xzf /tmp/node-v${node_ver}-linux-x64.tar.gz
  sudo rm -f /tmp/node-v${node_ver}-linux-x64.tar.gz CHANGELOG.md LICENSE README.md
  sudo chown -R root:root .
fi

# casper js
if [ ! -d ~/casperjs ]; then
  git clone git://github.com/n1k0/casperjs.git ~/casperjs
fi
cd ~/bin
ln -snf ../casperjs/bin/casperjs casperjs

# packer
packer_ver='1.0.0'
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
