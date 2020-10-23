# enable git command completion
if [[ $OSTYPE =~ ^darwin ]]; then
  for f in /usr/local/etc/bash_completion.d/* ; do
    source $f
  done
fi

if [[ $OSTYPE =~ ^linux ]]; then
  if grep -q '\(Amazon Linux AMI\|CentOS Linux 7\)' /etc/os-release; then
    git_bash_completion_sh="/usr/share/doc/git-$(rpm -q --queryformat '%{VERSION}' git 2>/dev/null)/contrib/completion/git-completion.bash"
    [ -f "$git_bash_completion_sh" ] && source "$git_bash_completion_sh"
  fi
  if [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ]; then
    source /usr/share/git-core/contrib/completion/git-prompt.sh
  fi
fi
