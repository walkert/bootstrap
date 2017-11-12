#!/bin/bash

. ${1}/vars.sh
. ${1}/common.sh

tmux_dir="${binaries_dir}/tmux"
tmux="${tmux_dir}/bin/tmux"

install_tmux(){
    set -e
    local tfile="tmux.tgz"
    local dltemp=$(mktemp -d)
    wget -O $tfile "${tmux_repo_base}/${tmux_version}/${tmux_tar_name}" &>/dev/null
    tar -C $dltemp --strip 1 -xzf $tfile &>/dev/null
    cd $dltemp
    ./configure --prefix=$tmux_dir &>/dev/null
    make &>/dev/null
    make install &>/dev/null
    rm -rf $tfile $dltemp
    set +e
}


if [ -e $tmux ] ; then
    if ! $tmux -V | grep -q $tmux_version ; then
        rm -rf $tmux_dir
    else
        exit
    fi
fi
check_dev_pkgs
echo "Installing tmux.."
install_tmux
ln -s ${tmux} ${bin_dir}/tmux
