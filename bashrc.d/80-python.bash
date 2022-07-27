# helpers to create Python virtual environments

mk_py_virtualenv() {
  echo 'Fatal: mk_py_virtualenv is deprecated!' >&2
  echo 'Use dev_py_virtualenv or aws_py_virtualenv instead' >&2
}

get_python_dir() {
    cd "$(dirname "$1")"
    count=${2:-0}
    if [ $count -gt 10 ]; then
        echo "Fatal: too many symlinks finding base python path" >&2
        return 1
    fi
    binpath=$(readlink "$(basename "$1")")
    if [ -z "$binpath" ]; then
        cd .. && pwd
        return $?
    else
        get_python_dir "$binpath" $(( $count + 1 ))
        return $?
    fi
}

create_virtualenv() {
  if [[ -z $1 ]]; then
    echo "Usage: create_virtualenv <name> [/path/to/python]" >&2
    return 1
  fi
  if [[ ${1:0:1} == '.' ]]; then
    name="$1"
  else
    name=".$1"
  fi
  python_cmd=${2:-python3}
  if [[ $(basename "$python_cmd") == $python_cmd ]]; then
      python_path=$(which "$python_cmd")
  else
      python_path=$python_cmd
  fi

  python_version_str=$($python_path --version 2>&1)
  if ! [[ $python_version_str =~ ^Python\ [23][.][0-9]+[.][0-9]+$ ]]; then
    echo "Fatal: $python_path --version fails [$python_version_str]" >&2
    echo "Usage: dev_py_virtualenv <name> [/path/to/python]" >&2
    return 1
  fi
  python_version=$(echo $python_version_str | sed 's/^Python \([23][.][0-9]\+\)[.].*$/\1/')

  # determine where python is installed
  if [[ $python_path =~ / ]]; then
    python_home=$(get_python_dir "$python_path")
  else
    python_home=$(get_python_dir "$(which $python_path)")
  fi

  virtualenv -p "$python_path" "$name"

  if [ -n "$python_home" ]; then
    pushd "$name" > /dev/null
    ln -snf "$python_home" PythonHome
    popd > /dev/null
  fi
}

dev_py_virtualenv() {
  if [[ -z $1 ]]; then
    echo "Usage: dev_py_virtualenv <name> [/path/to/python]" >&2
    return 1
  fi
  create_virtualenv "$@" || return $?
  if [[ ${1:0:1} == '.' ]]; then
    name="$1"
  else
    name=".$1"
  fi

  # only install ipython terminal on Linux
  if [ "$(uname -s)" = 'Darwin' ]; then
    ipy_install_type='all'
  else
    ipy_install_type='terminal'
  fi

  . "$name/bin/activate" && \
    pip install --upgrade pip && \
    pip install --upgrade flake8 boto3 awscli cfn-lint pyOpenSSL grip gnureadline yamllint elasticsearch kubernetes 'pykube-ng[gcp]' && \
    pip install --upgrade autopep8 black coverage docker PyGithub pytest pytest-cov pytest-mock toml tzlocal && \
    pip install --upgrade "ipython[$ipy_install_type]" && \
      deactivate
}

aws_py_virtualenv() {
  if [[ -z $1 ]]; then
    echo "Usage: aws_py_virtualenv <name> [/path/to/python]" >&2
    return 1
  fi
  create_virtualenv "$@" || return $?
  if [[ ${1:0:1} == '.' ]]; then
    name="$1"
  else
    name=".$1"
  fi
  . "$name/bin/activate" && \
    pip install --upgrade pip && \
    pip install --upgrade awscli kubernetes && \
      deactivate
}
