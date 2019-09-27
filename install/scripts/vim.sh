#!/bin/bash
#
# Name: vim.sh
# Desc: Install a lua/python-enabled vim (if required) and get Vundle plugins

. ${1}/vars.sh
. ${1}/common.sh

bundle_dir=$(dirname $vundle_dir)
plug_install=false
vim=("${binaries_dir}/vim/bin/vim")

install_vim(){
    if is_redhat ; then
        install_pkg "${vim_reqs_red[@]}"
    else
        install_pkg "${vim_reqs_deb[@]}"
    fi
    local vim_tmp=$(mktemp -d)
    run "git clone $vim_repo $vim_tmp"
    cd $vim_tmp
    run "./configure --enable-python3interp --prefix=${binaries_dir}/vim"
    run "make"
    run "make install"
    cd - &>/dev/null
    run "rm -rf $vim_tmp"
    ensure_link ${vim} ${bin_dir}/vim
}

ensure_dir $bundle_dir

if [ ! -e $vundle_dir ] ; then
    run "git clone $vundle $vundle_dir"
    plug_install=true
fi
if [ ! -e $vim ] ; then
    echo "Installing vim.."
    install_vim
fi
if [ ${plug_install} = "true" ] ; then
    run "$vim +PluginInstall +qall"
fi
