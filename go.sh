#!/bin/bash
set -ex

target_sys='unknown'
dev_install='false'
case "$OSTYPE" in
  darwin*)
    target_sys=osx
    export dev_install='true'
    ;;
  linux*)
    . /etc/os-release || exit $?
    case "$ID" in
      amzn)
        target_sys=amzn-linux
        ;;
      centos)
        if [[ $VERSION_ID == 7 ]]; then
          target_sys=centos7
        else
          echo "Unsupported version of CentOS: $VERSION" >&2
          exit 1
        fi
        ;;
      #rhel)
      #  ;;
      ubuntu)
        if [[ $VERSION_ID =~ 16\. ]]; then
          target_sys=ubuntu16
        else
          echo "Unsupported version of Ubuntu: $VERSION" >&2
          exit 1
        fi
        ;;
      debian)
        if [[ $VERSION_ID == 10 ]]; then
          target_sys=debian10
        else
          echo "Unsupported version of Debian: $VERSION" >&2
          exit 1
        fi
        ;;
      *)
        echo "Unsupported Linux distro: $NAME $VERSION" >&2
        exit 1
        ;;
    esac
    ;;
esac

if [ "$target_sys" = 'unknown' ]; then
  echo "Fatal: Unknown system type '$OSTYPE'" >&2
  uname -a >&2
fi

if [ "$1" = 'dev' ]; then
  export dev_install='true'
fi

# make sure $HOME/bin exists
mkdir -m0755 -p ~/bin

# go to .dotfiles root and update submodules
cd "$(dirname $0)"

git submodule update --init --recursive

# run setup scripts for the target systems
for script in ./setup/$target_sys/*.sh; do
  if [ ! -f "$script" -o ! -x "$script" ]; then
    echo "Warning: $script is not executable and/or not a file ... skipping" >&2
  else
    $script
  fi
done
