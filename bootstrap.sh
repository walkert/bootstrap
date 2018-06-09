#!/bin/bash

run_scripts(){
    # Run each of the installation scripts
    for script in $@ ; do
        echo "Running $script.."
        if ! ${BASE}/install/scripts/$script ${BASE}/install ; then
            break
        fi
    done
}

BASE=$(cd $(dirname $0); pwd)
. ${BASE}/install/vars.sh
. ${BASE}/install/common.sh
if [ "$1" = "minimal" ] ; then
    echo "Performing minimal install.."
    run_scripts "${minimal_scripts[@]}"
    exit 0
fi
echo "Checking base packages.."
install_pkg "${base_packages[@]}"
PY_DIR="$(python -m site --user-base)/bin"
export PATH=$PY_DIR:$PATH
LOCAL_PIP="${PY_DIR}/pip"

# Get pip if required
if [ ! -e "$LOCAL_PIP" ] ; then
    echo "Installing pip..."
    if ! curl -s -O https://bootstrap.pypa.io/get-pip.py ; then
        echo "Error downloading get-pip.py!"
        exit 1
    fi
    python get-pip.py --user &>/dev/null
    rm -f get-pip.py
    if [ ! -x $LOCAL_PIP ] ; then
        echo "Can't find pip after installation!"
        exit 1
    fi
fi
if ! $LOCAL_PIP freeze|grep -q virtualenv ; then
    echo "Installing virtualenv..."
    if ! $LOCAL_PIP install --user virtualenv &>/dev/null ; then
        echo "Error installing virtualenv!"
        exit 1
    fi
fi

# Make sure xcode CLI tools are setup and install Homebrew
if [ $(uname -s) = "Darwin" ] ; then
    xcode=$(xcode-select --install 2>&1)
    if [ $? -ne 0 ] ; then
        if ! grep -q "already installed" <<< "$xcode" ; then
            echo "Unexpected error from xcode-install"
            exit 1
        fi
    fi
    if [ ! -x /usr/local/bin/brew ] ; then
        echo "Installing Homebrew..."
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" &>/dev/null
    fi
fi

run_scripts $(ls ${BASE}/install/scripts)
