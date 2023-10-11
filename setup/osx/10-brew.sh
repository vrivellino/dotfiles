#!/usr/bin/env bash
set -ex

if ! which brew > /dev/null 2>&1 ; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.profile
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  brew update
  brew upgrade
fi

brew install automake bash coreutils git gnu-getopt gnu-sed gnu-tar gpg maven node packer pkg-config tidy-html5 tree
brew install cmake czmq libffi libyaml python@3.11 cfn-lint flake8 yamllint macvim jq yq
brew install vault docker kubernetes-cli kustomize kubeseal kubectx
brew install --cask google-cloud-sdk

## Commenting out due to Homebrew warning
## El Capitan (and presumably higher) does not ship openssl headers
#darwinversion=$(echo $OSTYPE | sed 's/^darwin//' | cut -f 1 -d .)
#if [ $darwinversion -ge 15 ]; then
#    brew link openssl --force
#fi
