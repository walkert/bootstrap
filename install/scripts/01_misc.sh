#!/bin/bash
#
# Name: 01_misc.sh
# Desc: Misc setup items (runs before all other scripts)

. ${1}/vars.sh
. ${1}/common.sh
for dir in ${create_dirs[@]} ; do
    ensure_dir $dir
done

# Setup linuxbrew if we're on linux
if is_linux ; then
    if [ ! -d ~/.linuxbrew ] && [ ! -d /home/linuxbrew/.linuxbrew ] ; then
        export CI=true
        if ! sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)" >/dev/null 2>&1 ; then
            echo "Unable to install linuxbrew"
            exit 1
        fi
    fi
fi

# Install brew-based packages
for pkg in "${brew_packages[@]}" ; do
    brew_install $pkg
done

# Explicit exit to ignore ensure_dir return code
exit 0
