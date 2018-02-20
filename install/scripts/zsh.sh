#!/bin/bash
#
# Name: zsh.sh
# Desc: Setup zsh extras

. ${1}/vars.sh
. ${1}/common.sh

mkdir -p ~/.zsh
cd ~/.zsh
for extra in ${zsh_extras[*]} ; do
    dir=$(basename $extra)
    if [ ! -d ${dir%.git} ] ; then
        run "git clone $extra"
    fi
done
