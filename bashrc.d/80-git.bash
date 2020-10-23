export GIT_EDITOR=vim

if type -t __git_ps1 > /dev/null; then
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

# helper to update git config for local repo
git_config_update_localrepo() {
  if [ -s ../.git-email ]; then
    git config user.email "$(cat ../.git-email)"
  fi
  if [ -s ../.git-signing-key ]; then
    git config user.signingKey "$(cat ../.git-signing-key)"
  fi
  if [ -s ../.git-username ]; then
    git config user.name "$(cat ../.git-username)"
  fi
}

# helper to update git config for existing repos
git_config_update_all() {
  pushd "$PROJECT_BASE_DIR" > /dev/null || return 1
  for d in */* ; do
    if [ -d "$d/.git" ] && pushd "$d" > /dev/null; then
      echo "Ensuring local git config in $d"
      git_config_update_localrepo
      popd > /dev/null
    fi
  done
  popd > /dev/null
}

# automatically set email if parent dir has a .git-email file
git_clone() {
  git clone "$@"
  if cd "$(basename "$1" .git)"; then
    git_config_update_localrepo
  fi
}

# alias.dm=!git branch --merged | grep -v '\*' | xargs -n 1 git branch -d
