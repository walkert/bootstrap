#!/bin/bash
#
# Name: vim.sh
# Desc: Install a lua/python-enabled vim (if required) and get Vundle plugins

. ${1}/vars.sh
. ${1}/common.sh

bundle_dir=$(dirname $vundle_dir)
plug_install=false
vim="/home/linuxbrew/.linuxbrew/bin/vim"

ensure_dir $bundle_dir

if [ ! -e $vundle_dir ] ; then
    run "git clone $vundle $vundle_dir"
    plug_install=true
fi
export GOROOT=~/Binaries/go
export GOPATH=~/Go
export PATH=$PATH:${GOROOT}/bin

if [ ${plug_install} = "true" ] ; then
    echo "  Installing vim plugins.."
    run "$vim +PluginInstall +qall"
fi
