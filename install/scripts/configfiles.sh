#!/bin/bash
#
# Name: configfile.sh
# Desc: Symlink ~/.config files

. ${1}/vars.sh
. ${1}/common.sh

MAC_ONLY=(karabiner)

for dir in $(ls ${1}/../config) ; do
    if grep -q ${dir} <<< ${MAC_ONLY[*]} ; then
        if ! is_mac ; then
            continue
        fi
    fi
    dest="${HOME}/.config/$dir"
    if [ ! -d $dest ] ; then
        mkdir -p $dest
    fi
    for file in $(ls ${1}/../config/${dir}) ; do
        dest_file="${HOME}/.config/$dir/$file"
        if [ -L $dest_file ] ; then
            continue
        fi
        ensure_link ${1}/../config/${dir}/${file} $dest_file
    done
done
