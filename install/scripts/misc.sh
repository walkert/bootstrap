#!/bin/bash

. ${1}/vars.sh
for dir in ${create_dirs[@]} ; do
    mkdir -p $dir &>/dev/null
done
