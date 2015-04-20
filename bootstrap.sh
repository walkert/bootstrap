#!/bin/bash

# Get pip
BIN_DIR="$(python -m site --user-base)/bin"
if [ ! -e ${BIN_DIR}/pip ] ; then
    echo "Installing pip..."
    if ! curl -s -O https://bootstrap.pypa.io/get-pip.py ; then
        echo "Error downloading get-pip.py!"
        exit 1
    fi
    python get-pip.py --user
    rm -f get-pip.py
    if [ ! -x ${BIN_DIR}/pip ] ; then
        echo "Can't find pip after installation!"
        exit 1
    fi
    export PATH=$PATH:$BIN_DIR
    echo "Installing ansible..."
    if ! pip install --user ansible &>/dev/null ; then
        echo "Error installing ansible!"
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
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
fi

# Perform the ansible run
pushd ansible &>/dev/null
ansible-playbook -i hosts config.yml
popd &>/dev/null
