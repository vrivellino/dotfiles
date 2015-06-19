#!/bin/bash

git submodule init
git submodule update

cd && ln -snf .dotfiles/.bashrc .bashrc_vr

if ! grep -F 'source ~/.bashrc_vr' ~/.bashrc; then
  echo '[ -f ~/.bashrc_vr ] && source ~/.bashrc_vr' >> ~/.bashrc
fi

# setup vim
mkdir -p .vim/autoload
ln -snf ~/.dotfiles/vim-pathogen/autoload/pathogen.vim .vim/autoload/pathogen.vim

if [ -d .vim/bundle ]; then
  echo 'Warning: .vim/bundle exists ... not adding vim plugins'
else
  ln -snf ~/.dotfiles/vim/bundle .vim/bundle
fi

if [ -s ~/.vimrc ]; then
  mv ~/.vimrc ~/.vimrc.pre-vr
fi
rm -f ~/.vimrc
ln -s .dotfiles/.vimrc .vimrc

if [ -e ~/.lein ] && ! [ -h ~/.lein ]; then
  mv ~/.lein ~/.lein.pre-vr
fi
ln -s .dotfiles/.lein .lein

echo '<ENTER> to install IPython ...'
read junk

if ! sudo yum install python-zmq python-pygments openssl-devel libffi-devel; then
  echo
  echo 'Tried to install python-zmq, python-pygments, etc. via yum.'
  echo '<ENTER> to continue if you are sure they are available ...'
  read junk
fi

# IPython and its dependencies must be installed site-wide
if [ "$(uname -s)" = 'Darwin' ]; then
  sudo pip install --upgrade gnureadline
fi
sudo pip install --upgrade "ipython[all]"
