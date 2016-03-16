# source everything in bashrc.d
for bashrc in ~/.dotfiles/bashrc.d/*.bash ; do
  . "$bashrc"
done

export HISTSIZE=25000
export HISTFILESIZE=500000

# look for aws creds and/or local overrides
[ -f ~/.bashrc_aws ] && source ~/.bashrc_aws
if [ -n "$(ls -1 ~/Projects/*/.bashrc 2> /dev/null)" ]; then
  for projdir in ~/Projects/*/.bashrc ; do
    source "$projdir"
  done
fi
[ -f ~/.bashrc_local ] && source ~/.bashrc_local

# needed for vim-ipython
stty stop undef
