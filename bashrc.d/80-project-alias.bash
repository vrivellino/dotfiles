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
