install_go() {
    go_version="$1"
    install_path=/usr/local/go
    if [ -z "$go_version" ]; then
        echo "Usage: install_go <version>" >&2
        echo >&2
        echo "visit https://go.dev/dl/ for releases" >&2
        return 1
    fi
    os=''
    arch=''
    case $OSTYPE in
        linux*)
            os=linux
            ;;
        darwin*)
            os=darwin
            ;;
        *)
            echo "Fatal: unknown \$OSTYPE $OSTYPE!" >&2
            return 1
    esac
    case $HOSTTYPE in
        x86_64)
            arch=amd64
            ;;
        #arm*) ?
        #    arch=arm64
        #    ;;
        *)
            echo "Fatal: unknown \$HOSTTYPE $HOSTTYPE!" >&2
            return 1
    esac
    sudo whoami >/dev/null || return $?

    if -d "$install_path.old" ; then
        echo "$install_path.old exists; it will be deleted"
        read input -p "Press <ENTER> to continue ..."
    fi
    targz=go${go_version}.$os-$arch.tar.gz
    temp_dir=$(mktemp -d)
    cur_dir=$(pwd)

    cd $temp_dir
    curl -L -o $targz https://go.dev/dl/$targz
    if ! [ -s "$targz" ]; then
        echo "Fatal: curl -L -o $targz https://go.dev/dl/$targz failed ... aborting" >&2
        cd "$cur_dir"
        rm -rf $temp_dir
        return 1
    fi
    tar xvf $targz
    if ! sudo chown -R 0:0 go ; then
        cd "$cur_dir"
        rm -rf $temp_dir
        return 1
    fi
    if ! sudo chmod -R go-w go ; then
        cd "$cur_dir"
        rm -rf $temp_dir
        return 1
    fi
    test -d "$install_path.old" && sudo rm -rf "$install_path.old"
    sudo mv go "$install_path"
    cd "$cur_dir"
    rm -rf $temp_dir
}

if [ -d /usr/local/go ]; then
    export GOROOT=/usr/local/go
    export PATH="$GOROOT/bin:$PATH"
fi

export GOPATH=~/go
export PATH="$GOPATH/bin:$PATH"
