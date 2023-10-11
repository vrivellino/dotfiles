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

for d in /usr/local/share/npm/bin /usr/local/bin "$HOME/.rbenv/bin" "$HOME/.npm-packages/bin"; do
  [ -d "$d" ] && new_path="$d:$new_path"
done

if [ -d "$HOME/.npm-packages/share/man" ]; then
  # Preserve MANPATH if you already defined it somewhere in your config.
  # Otherwise, fall back to `manpath` so we can inherit from `/etc/manpath`.
  export MANPATH="${MANPATH-$(manpath)}:$HOME/.npm-packages/share/man"
fi

if [ ! -d "$HOME/bin" ]; then
  mkdir -m 0750 "$HOME/bin"
fi
if [[ $OSTYPE =~ darwin ]] && [ -e /usr/local/bin/mvim ]; then
  ln -snf /usr/local/bin/mvim $HOME/bin/vim
  for pydir in ~/Library/Python/* ; do
      if [[ -d $pydir/bin ]]; then
          new_path="${new_path}:$pydir/bin"
      fi
  done
fi

export PATH="./node_modules/.bin:$HOME/bin:$new_path"

if [[ $OSTYPE =~ darwin ]] && [[ -n $HOMEBREW_PREFIX ]] && [[ -e $HOMEBREW_PREFIX/share/google-cloud-sdk/path.bash.inc ]]; then
    source "$(brew --prefix)/share/google-cloud-sdk/path.bash.inc"
fi
