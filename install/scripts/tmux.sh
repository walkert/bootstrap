#!/bin/bash
#
# Name: tmux.sh
# Desc: Install tmux if required

. ${1}/vars.sh
. ${1}/common.sh

tmux_scripts_dest="${HOME}/.tmux"
tmux_scripts_source="$(dirname $1)/tmux"

install_plugins(){
    plug_dir="${tmux_scripts_source}/plugins"
    ensure_dir $plug_dir
    for plugin in "${tmux_plugins[@]}" ; do
        plug_name=$(basename $plugin)
        plug_dest=${plug_dir}/$plug_name
        if [ -d $plug_dest ] ; then
            continue
        fi
        run "git clone $plugin $plug_dest"
        if [ $plug_name = "tmux-fingers" ] ; then
            cd ${plug_dest}
            run "git submodule update --init --recursive"
        fi
    done
}

install_tmux(){
    for pkg in "${tmux_brew_packages[@]}" ; do
        brew_install $pkg
    done
}


if [ ! -L $tmux_scripts_dest ] ; then
    ensure_link $tmux_scripts_source $tmux_scripts_dest
fi
echo "Installing tmux.."
install_tmux
install_plugins
