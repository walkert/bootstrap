#!/bin/bash
#
# Name: 01_misc.sh
# Desc: Misc setup items (runs before all other scripts)

. ${1}/vars.sh
for dir in ${create_dirs[@]} ; do
    mkdir -p $dir &>/dev/null
done
