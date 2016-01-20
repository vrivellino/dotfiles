# base dir for projects
: ${PROJECT_BASE_DIR:=~/Projects}

proj() {
    if [ -n "$1" -a -n "$2" ]; then
        cd "$PROJECT_BASE_DIR/$1/$2/"
    elif [ -n "$1" ]; then
        cd "$PROJECT_BASE_DIR/$1/"
    else
        git_cdup=$(git rev-parse --show-cdup 2>/dev/null)
        if [ -n "$git_cdup" ]; then
            cd $git_cdup
            return $?
        fi
        return 1
    fi
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
