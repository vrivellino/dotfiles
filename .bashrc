# setup PATH
user_local_bin_found=''
npm_bin_found=''
home_bin_found=''
OLDIFS="$IFS"
IFS=':'
for d in $PATH; do
  [ "$d" = '/usr/local/bin' ] && user_local_bin_found='true'
  [ "$d" = '/usr/local/share/npm/bin' ] && npm_bin_found='true'
  [ "$d" = "$HOME/bin" ] && home_bin_found='true'
done
IFS="$OLDIFS"

[ -n "$user_local_bin_found" ] || export PATH=/usr/local/bin:$PATH
[ -n "$npm_bin_found" ] || [ -d "/usr/local/share/npm/bin" ] \
  && export PATH="/usr/local/share/npm/bin:$PATH"
[ -n "$home_bin_found" ] || export PATH="$HOME/bin:$PATH"

if [ -d "$HOME/.rvm/bin" ]; then
  export PATH=$PATH:$HOME/.rvm/bin
fi

# Mac-specifics
if [ "$(uname -s)" = 'Darwin' ]; then
  CLICOLOR=1
  LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
  LC_ALL=POSIX
  export CLICOLOR LSCOLORS LC_ALL
  alias ls='ls -F -T -b -a'

  # gnu tools I need on my mac
  gsed_path="$(which gsed 2>&1)"
  [ -z "$gsed_path" ] || alias sed="$gsed_path"
  gnugetopt_path="$(which gnut-getopt 2>&1)"
  [ -z "$gnugetopt_path" ] || export GNU_GETOPT="$gnugetopt_path"

# Linux-specifics
elif [ "$(uname -s)" = 'Linux' ]; then
  alias ls='LC_ALL=POSIX ls --color=auto -F -T 0 -b -a'
fi

alias vi=vim
alias grep='grep --color'
alias ipycon="ipython qtconsole > ~/.ipython/con.out 2>&1 &"
# needed for vim-ipython
stty stop undef

HISTFILESIZE=10000
export HISTFILESIZE

# setup git prompt
git_bash_completion=''
for d in /usr/local/etc/bash_completion.d /usr/share/git-core/contrib/completion ; do
  if [ -f "$d/git-prompt.sh" ]; then
    git_bash_completion="$d/git-prompt.sh"
    break
  fi
done

if source $git_bash_completion; then
  # PRE and POST vars make prompt look like this:
  # <GIT_PS1_PRE> <GIT-PROMPT> <GIT_PS1_POST>
  export GIT_PS1_PRE='\[\033[01;32m\]\u\[\033[01;34m\]@\h\[\033[00m\] \w'
  export GIT_PS1_POST='\$ '

  # setup git prompt options
  export GIT_PS1_SHOWUNTRACKEDFILES='true'
  export GIT_PS1_SHOWDIRTYSTATE='true'
  export GIT_PS1_SHOWUPSTREAM='verbose'
  export GIT_PS1_SHOWCOLORHINTS='true'
  export GIT_PS1_DESCRIBE_STYLE='describe'

  ## Various old options
  #export PROMPT_COMMAND='__git_ps1 "\u@\h:\w" "\\\$ "'
  #export PROMPT_COMMAND='echo -ne "\\033]0;${PWD/#$HOME/~}\\007"; __git_ps1 "[\\[\\033[01;32m\\]\\u\\[\\033[01;34m\\]@\\h\\[\\033[00m\\] \\w]" "\\\$ "'
#export PROMPT_COMMAND='echo -ne "\\033]0;${PWD/#$HOME/~}\\007"; __git_ps1 "[$GIT_PS1_PRE]" "$GIT_PS1_POST"'

  # helper function to inject Python VirtualEnv name into prompt
  _virtenv_git_ps1() {
    ps1_pre_tmp="$GIT_PS1_PRE"
    if [ -n "$VIRTUAL_ENV" ]; then
      __git_ps1 "[$(basename $VIRTUAL_ENV) $1]" "$2"
    else
      __git_ps1 "[$1]" "$2"
    fi
  }

  # actual thing that changes the prompt
  export PROMPT_COMMAND='echo -ne "\\033]0;${PWD/#$HOME/~}\\007"; _virtenv_git_ps1 "$GIT_PS1_PRE" "$GIT_PS1_POST"'
fi

# useful functions
watch_elb_health() {
  elb="$1"
  [ -z "$elb" ] && return 1
  while echo -e "\n----- $elb ----" && aws elb describe-instance-health --output text --load-balancer-name "$elb"; do sleep 10 ; done
}

# look for aws creds and/or local overrides
[ -f ~/.bashrc_aws ] && source ~/.bashrc_aws
[ -f ~/.bashrc_local ] && source ~/.bashrc_local
