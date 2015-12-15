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

for d in /usr/local/share/npm/bin /usr/local/bin $HOME/bin ; do
  [ -d "$d" ] && new_path="$d:$new_path"
done

export PATH="./node_modules/.bin:$new_path"
