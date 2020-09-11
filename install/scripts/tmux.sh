#!/bin/bash
#
# Name: tmux.sh
# Desc: Install tmux if required

. ${1}/vars.sh
. ${1}/common.sh

tmux_scripts_dest="${HOME}/.tmux"
tmux_scripts_source="$(dirname $1)/tmux"

install_tmux(){
    for pkg in "${tmux_brew_packages[@]}" ; do
        brew_install $pkg
    done
}

if [ ! -L $tmux_scripts_dest ] ; then
    ensure_link $tmux_scripts_source $tmux_scripts_dest
fi
install_tmux
