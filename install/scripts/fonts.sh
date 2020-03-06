#!/bin/bash
#
# Name: fonts.sh
# Desc: Install fonts

. ${1}/vars.sh
. ${1}/common.sh

if ! is_linux ; then
    exit
fi
fonts=${HOME}/.fonts
ensure_dir $fonts
for i in $(seq 0 ${#fonts_expect[@]}) ; do
    font_file=${fonts_expect[$(($i-1))]}
    font_loc=${fonts_dl[$(($i-1))]}
    if [ -e ${fonts}/$font_file ] ; then
        continue
    fi
    tfile=/tmp/$font_file
    run "wget -O $tfile $font_loc"
    run "unzip $tfile -d $fonts"
    run "rm -rf $tfile"
    run "fc-cache $fonts"
done
