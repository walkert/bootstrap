#!/bin/bash
#
# Name: tmux.sh
# Desc: Install tmux if required

. ${1}/vars.sh
. ${1}/common.sh

tmux_dir="${binaries_dir}/tmux"
tmux=("${tmux_dir}/bin/tmux")
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
    if is_mac ; then
        brew_install tmux
        return
    fi
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
    ensure_link ${tmux} ${bin_dir}/tmux
}


if [ ! -L $tmux_scripts_dest ] ; then
    ensure_link $tmux_scripts_source $tmux_scripts_dest
fi
installed=$(which tmux 2>/dev/null)
if [ -n "$installed" ] ; then
    tmux+=($installed)
fi
for binary in ${tmux[*]} ; do
    if [ ! -e $binary ] ; then
        continue
    fi
    if $binary -V | grep -q $tmux_version ; then
        install_plugins
        exit
    fi
done
install_devel
echo "Installing tmux.."
install_tmux
install_plugins
