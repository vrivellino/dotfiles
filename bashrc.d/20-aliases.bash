# Mac-specifics
if [[ $OSTYPE =~ ^darwin ]]; then
  export GPG_TTY=$(tty)
  CLICOLOR=1
  LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
  export CLICOLOR LSCOLORS
  alias ls='LC_ALL=POSIX ls -F -T -b -a'

  # gnu tools I need on my mac
  gsed_path="$(which gsed 2>&1)"
  [ -z "$gsed_path" ] || alias sed="$gsed_path"
  gtar_path="$(which gtar 2>&1)"
  [ -z "$gtar_path" ] || alias tar="$gtar_path"
  gnugetopt_path="$(which gnu-getopt 2>&1)"
  [ -z "$gnugetopt_path" ] || export GNU_GETOPT="$gnugetopt_path"

# Linux-specifics
elif [[ $OSTYPE =~ ^linux ]]; then
  alias ls='LC_ALL=POSIX ls --color=auto -F -T 0 -b -a'
fi

# Common aliases
alias vi=vim
alias grep='grep --color'
alias zgrep='zgrep --color'
alias fgrep='fgrep --color'

alias myip='curl https://ucanhazip.co'

# random password generator
randpass() {
    local lc_all_old="$LC_ALL"
    export LC_ALL=POSIX
    < /dev/urandom tr -dc '_.!@#$%^&*A-Z-a-z-0-9' | head -c${1:-10};echo;
    < /dev/urandom tr -dc '_.!@#$%^&*A-Z-a-z-0-9' | head -c${1:-12};echo;
    < /dev/urandom tr -dc '_.!@#$%^&*A-Z-a-z-0-9' | head -c${1:-16};echo;
    echo
    < /dev/urandom tr -dc A-Z-a-z-0-9 | head -c${1:-10};echo;
    < /dev/urandom tr -dc A-Z-a-z-0-9 | head -c${1:-12};echo;
    < /dev/urandom tr -dc A-Z-a-z-0-9 | head -c${1:-16};echo;
    export LC_ALL="$lc_all_old"
}

# wrapper for vim on ubuntu
if [[ $OSTYPE =~ ^linux ]] && [ -f /etc/os-release ] && grep -q -F 'Ubuntu 16.' /etc/os-release; then
    vim() {
        if [[ $(python --version 2>&1) =~ ^Python\ 2\. ]]; then
            vim.nox-py2 "$@"
        else
            vim.nox "$@"
        fi
    }
# make sure we're using homebrew'd macvim on OSX
elif [[ $OSTYPE =~ ^darwin ]]; then
    alias vim=/usr/local/bin/vim
fi
