# helpers to create Python virtual environments

mk_py_virtualenv() {
  echo 'Fatal: mk_py_virtualenv is deprecated!' >&2
  echo 'Use dev_py_virtualenv or aws_py_virtualenv instead' >&2
}

dev_py_virtualenv() {
  name="$1"
  if [ -z "$name" ]; then
    echo "Usage: dev_py_virtualenv <name> [/path/to/python]" >&2
    return 1
  fi

  python_path=$(which python2.7)
  if [ -n "$2" ]; then
    python_path="$2"
    if ! $python_path --version 2>&1 | grep -q '^Python [23][.][0-9]\+[.][0-9]\+$'; then
      echo "Fatal: $python_path --version fails" >&2
      echo "Usage: mk_py_virtualenv <name> [/path/to/python]" >&2
      return 1
    fi
  fi

  # only install ipython terminal on Linux
  if [ "$(uname -s)" = 'Darwin' ]; then
    ipy_install_type='all'
  else
    ipy_install_type='terminal'
  fi

  virtualenv --system-site-packages -p "$python_path" ".$name" && \
    . ".$name/bin/activate" && \
    pip install --upgrade pip && \
    pip install --upgrade pep8 boto boto3 awscli pyOpenSSL grip gnureadline && \
    pip install --upgrade "ipython[$ipy_install_type]" && \
      deactivate
}

aws_py_virtualenv() {
  name="$1"
  if [ -z "$name" ]; then
    echo "Usage: aws_py_virtualenv <name> [/path/to/python]" >&2
    return 1
  fi

  python_path=$(which python2.7)
  if [ -n "$2" ]; then
    python_path="$2"
    if ! $python_path --version 2>&1 | grep -q '^Python [23][.][0-9]\+[.][0-9]\+$'; then
      echo "Fatal: $python_path --version fails" >&2
      echo "Usage: mk_py_virtualenv <name> [/path/to/python]" >&2
      return 1
    fi
  fi

  virtualenv --system-site-packages -p "$python_path" ".$name" && \
    . ".$name/bin/activate" && \
    pip install --upgrade pip && \
    pip install --upgrade boto awscli && \
      deactivate
}
