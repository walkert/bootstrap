#!/bin/bash
#
# Name: tmux.sh
# Desc: Install tmux if required

. ${1}/vars.sh
. ${1}/common.sh

tmux_dir="${binaries_dir}/tmux"
tmux="${tmux_dir}/bin/tmux"
tmux_scripts_dest="${HOME}/.tmux"
tmux_scripts_source="$(dirname $1)/tmux"

install_plugins(){
    plug_dir="${tmux_scripts_source}/plugins"
    if [ ! -d $plug_dir ] ; then
        mkdir $plug_dir
    fi
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
    if is_redhat ; then
        install_pkg "${tmux_reqs_red[@]}"
    else
        install_pkg "${tmux_reqs_deb[@]}"
    fi
    local tfile="tmux.tgz"
    local dltemp=$(mktemp -d)
    run "wget -O $tfile ${tmux_repo_base}/${tmux_version}/${tmux_tar_name}"
    run "tar -C $dltemp --strip 1 -xzf $tfile"
    cd $dltemp
    run "./configure --prefix=$tmux_dir"
    run "make"
    run "make install"
    cd - &>/dev/null
    run "rm -rf $tfile $dltemp"
    ln -s ${tmux} ${bin_dir}/tmux
}


if [ ! -L $tmux_scripts_dest ] ; then
    ln -s $tmux_scripts_source $tmux_scripts_dest
fi
if [ -e $tmux ] ; then
    if ! $tmux -V | grep -q $tmux_version ; then
        run "rm -rf $tmux_dir"
    else
        install_plugins
        exit
    fi
fi
install_devel
echo "Installing tmux.."
install_tmux
install_plugins
