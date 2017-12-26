#!/usr/bin/env bash
set -x

clone_dir="${TMPDIR:-/tmp}/powerline-fonts-$$"

install_powerline_fonts() {
    git clone https://github.com/powerline/fonts.git --depth=1 "$clone_dir" || return $?
    cd "$clone_dir" || return $?
    ./install.sh
    return $?
}

rm -rf "$clone_dir"
install_powerline_fonts
RC=$?
rm -rf "$clone_dir"
exit $RC
