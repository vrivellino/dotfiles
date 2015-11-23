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
  gtar_path="$(which gtar 2>&1)"
  [ -z "$gtar_path" ] || alias tar="$gtar_path"
  gnugetopt_path="$(which gnu-getopt 2>&1)"
  [ -z "$gnugetopt_path" ] || export GNU_GETOPT="$gnugetopt_path"

# Linux-specifics
elif [ "$(uname -s)" = 'Linux' ]; then
  alias ls='LC_ALL=POSIX ls --color=auto -F -T 0 -b -a'
fi

# Common aliases
alias vi=vim
alias grep='grep --color'
alias zgrep='zgrep --color'
alias fgrep='fgrep --color'
alias ipycon="mkdir -p ~/.ipython/ && ipython qtconsole > ~/.ipython/con.out 2>&1 &"

# random password generator
randpass() {
    < /dev/urandom tr -dc '_.!@#$%^&*A-Z-a-z-0-9' | head -c${1:-10};echo;
    < /dev/urandom tr -dc '_.!@#$%^&*A-Z-a-z-0-9' | head -c${1:-12};echo;
    < /dev/urandom tr -dc '_.!@#$%^&*A-Z-a-z-0-9' | head -c${1:-16};echo;
    echo
    < /dev/urandom tr -dc A-Z-a-z-0-9 | head -c${1:-10};echo;
    < /dev/urandom tr -dc A-Z-a-z-0-9 | head -c${1:-12};echo;
    < /dev/urandom tr -dc A-Z-a-z-0-9 | head -c${1:-16};echo;
}
