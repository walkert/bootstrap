#!/bin/bash
#
# Name: tmux.sh
# Desc: Install tmux if required

. ${1}/vars.sh
. ${1}/common.sh

tmux_scripts_dest="${HOME}/.tmux"
tmux_scripts_source="$(dirname $1)/tmux"

install_plugins(){
    echo "Installing tmux plugins"
    mkdir -p ~/.tmux/plugins
    for plugin in "${tmux_plugins[@]}" ; do
        run "git clone $plugin ${HOME}/.tmux/plugins/$(basename $plugin)"
    done
    run "${HOME}/.tmux/plugins/tpm/bin/install_plugins"
}

if [ ! -L $tmux_scripts_dest ] ; then
    ensure_link $tmux_scripts_source $tmux_scripts_dest
fi
if [ ! -d ~/.tmux/plugins ] ; then
    install_plugins
fi
