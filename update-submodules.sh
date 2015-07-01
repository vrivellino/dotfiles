#!/bin/bash

git submodule update --init --recursive

git submodule status | awk '{ print $2 }' | while read submodule_dir ; do
    if pushd "$submodule_dir" > /dev/null; then
        git checkout master
        git pull --rebase
        popd > /dev/null
        git commit -am "Pulled down update to $submodule_dir"
    fi
done
