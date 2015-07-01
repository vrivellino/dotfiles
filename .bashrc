# setup PATH - ensure $HOME/bin and /usr/local/bin are the front.
#              because I'm silly, I'm de-duping them too.
OLDIFS="$IFS"
IFS=':'
new_path=''
new_path_sep=''
for d in $PATH; do
  [ "$d" = '/usr/local/bin' ] && continue
  [ "$d" = '/usr/local/share/npm/bin' ] && continue
  [ "$d" = "$HOME/bin" ] && continue
  new_path="${new_path}${new_path_sep}${d}"
  new_path_sep=':'
done
IFS="$OLDIFS"

for d in /usr/local/share/npm/bin /usr/local/bin $HOME/bin $HOME/.rvm/bin ; do
  [ -d "$d" ] && new_path="$d:$new_path"
done
export PATH="./node_modules/.bin:$new_path"

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
  gnugetopt_path="$(which gnu-getopt 2>&1)"
  [ -z "$gnugetopt_path" ] || export GNU_GETOPT="$gnugetopt_path"

# Linux-specifics
elif [ "$(uname -s)" = 'Linux' ]; then
  alias ls='LC_ALL=POSIX ls --color=auto -F -T 0 -b -a'
fi

alias vi=vim
alias grep='grep --color'
alias zgrep='zgrep --color'
alias fgrep='fgrep --color'
alias ipycon="ipython qtconsole > ~/.ipython/con.out 2>&1 &"
# needed for vim-ipython
stty stop undef

GIT_EDITOR=vim
HISTFILESIZE=10000
export GIT_EDITOR HISTFILESIZE

# setup git prompt
git_bash_prompt_sh=''
for d in /usr/local/etc/bash_completion.d /usr/share/git-core/contrib/completion ; do
  if [ -f "$d/git-prompt.sh" ]; then
    git_bash_prompt_sh="$d/git-prompt.sh"
    break
  fi
done

if source $git_bash_prompt_sh; then
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

# automatically set email if parent dir has a .git-email file
git_clone() {
  git clone "$@"
  if cd "$(basename "$1" .git)" && [ -s ../.git-email ]; then
    git config user.email "$(cat ../.git-email)"
  fi
}

# useful functions
watch_elb_health() {
  elb="$1"
  [ -z "$elb" ] && return 1
  while echo -e "\n----- $elb ----" && aws elb describe-instance-health --output text --load-balancer-name "$elb"; do sleep 10 ; done
}

mk_py_virtualenv() {
  name="$1"
  if [ -z "$name" ]; then
    echo "Usage: $(basename $0) <name>" >&2
    exit 1
  fi

  cd && \
    virtualenv --system-site-packages -p $(which python2.7) ".$name" && \
    . ".$name/bin/activate" && \
    pip install --upgrade pep8 boto awscli pyOpenSSL && \
    deactivate
}

# from: http://ethertubes.com/bash-snippet-url-encoding/
_s3_urlencode () {
    local tab="$(echo -en "\x9")"
    local i="$@"

    i=${i//%/%25}  ; i=${i//' '/%20} ; i=${i//$tab/%09}
    i=${i//!/%21}  ; i=${i//\"/%22}  ; i=${i//#/%23}
    i=${i//\$/%24} ; i=${i//\&/%26}  ; i=${i//\'/%27}
    i=${i//(/%28}  ; i=${i//)/%29}   ; i=${i//\*/%2a}
    i=${i//+/%2b}  ; i=${i//,/%2c}   ; i=${i//-/%2d}
    i=${i//\./%2e} ; i=${i//\//%2f}  ; i=${i//:/%3a}
    i=${i//;/%3b}  ; i=${i//</%3c}   ; i=${i//=/%3d}
    i=${i//>/%3e}  ; i=${i//\?/%3f}  ; i=${i//@/%40}
    i=${i//\[/%5b} ; i=${i//\\/%5c}  ; i=${i//\]/%5d}
    i=${i//\^/%5e} ; i=${i//_/%5f}   ; i=${i//\`/%60}
    i=${i//\{/%7b} ; i=${i//|/%7c}   ; i=${i//\}/%7d}
    i=${i//\~/%7e}
    echo "$i"
}

# inspired from https://github.com/felixge/s3.sh
s3_signed_url() {
    local bucket=${1}
    local path=${2}
    local expires=${3:-600}

    if echo "$bucket" | grep -q '^s3://'; then
        path="$(echo $bucket | sed 's,^s3://[A-Za-z0-9._-]\+/,,')"
        bucket="$(echo $bucket | sed 's,^s3://\([A-Za-z0-9._-]\+\)/.*$,\1,')"
        expires=${2:-600}
    fi

    if [ -z "$bucket" -o -z "$path" ]; then
        echo "Usage: s3_signed_url <bucket> <path> [<expires>]" 2>&1
        echo "Usage: s3_signed_url s3://<bucket>/<path> [<expires>]" 2>&1
        return 1
    fi

    if [ -z "$AWS_ACCESS_KEY_ID" -o -z "$AWS_SECRET_ACCESS_KEY" ]; then
        echo "Fatal: \$AWS_ACCESS_KEY_ID and/or \$AWS_SECRET_ACCESS_KEY not set in env" 2>&1
        return 1
    fi

    local httpMethod='GET'
    local awsKey="$AWS_ACCESS_KEY_ID"
    local awsSecret="$AWS_SECRET_ACCESS_KEY"

    # Unix epoch number, defaults to 600 seconds in the future
    # local ts_expires=${expires:-$((`date +%s`+600))}
    local ts_expires=$((`date +%s` + $expires))
    local stringToSign="${httpMethod}\n\n\n${ts_expires}\n/${bucket}/${path}"
    local base64Signature=`echo -en "${stringToSign}" \
        | openssl dgst -sha1 -binary -hmac ${awsSecret} \
        | openssl base64`

    local escapedSignature=`_s3_urlencode ${base64Signature}`
    local escapedAwsKey=`_s3_urlencode ${awsKey}`

    local query="Expires=${ts_expires}&AWSAccessKeyId=${escapedAwsKey}&Signature=${escapedSignature}"
    echo "http://s3.amazonaws.com/${bucket}/${path}?${query}"
}

# base dir for projects
: ${PROJECT_BASE_DIR:=~/Projects}

 proj() {
    if [ -z "$1" -a -z "$2" ]; then
        echo "Usage: $(basename $0) <parent-dir> <project>" >&2
        return 1
    fi
    cd "$PROJECT_BASE_DIR/$1/$2"
}

# auto-complete parent dir
_proj_parent_dir()
{
    local cur=${COMP_WORDS[COMP_CWORD]}
    local prev=${COMP_WORDS[COMP_CWORD-1]}
    if [ $COMP_CWORD -eq 1 ]; then
        COMPREPLY=( $( compgen -W "$(cd "$PROJECT_BASE_DIR" && find . -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)" -- $cur ) )
    elif [ $COMP_CWORD -eq 2 ]; then
        COMPREPLY=( $( compgen -W "$(cd "$PROJECT_BASE_DIR/$prev" && find . -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)" -- $cur ) )
    fi
    return 0
}
 
complete -F _proj_parent_dir proj

# look for aws creds and/or local overrides
[ -f ~/.bashrc_aws ] && source ~/.bashrc_aws
[ -f ~/.bashrc_local ] && source ~/.bashrc_local
