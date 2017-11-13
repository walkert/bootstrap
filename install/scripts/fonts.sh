#!/bin/bash
#
# Name: fonts.sh
# Desc: Install fonts

. ${1}/vars.sh
. ${1}/common.sh

if [ ! $(os_type) = "linux" ] ; then
    exit
fi
fonts=${HOME}/.fonts
if [ ! -d $fonts ] ; then
    mkdir $fonts
fi
for i in $(seq 0 ${#fonts_expect[@]}) ; do
    font_file=${fonts_expect[$(($i-1))]}
    font_loc=${fonts_dl[$(($i-1))]}
    if [ -e ${fonts}/$font_file ] ; then
        continue
    fi
    tfile=/tmp/$font_file
    wget -O $tfile $font_loc &>/dev/null
    cd $fonts
    unzip $tfile &>/dev/null
    cd - &>/dev/null
    rm -rf $tfile
    fc-cache $fonts &>/dev/null
done
