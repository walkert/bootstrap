#!/bin/bash
#
# Name: 01_misc.sh
# Desc: Misc setup items (runs before all other scripts)

. ${1}/vars.sh
. ${1}/common.sh
for dir in ${create_dirs[@]} ; do
    ensure_dir $dir
done

# Install brew-based packages
#
for pkg in "${brew_packages[@]}" ; do
    brew_install $pkg
done

# Explicit exit to ignore ensure_dir return code
exit 0
