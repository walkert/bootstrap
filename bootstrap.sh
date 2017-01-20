#!/bin/bash

# Get pip
BASE=$(cd $(dirname $0); pwd)
PY_DIR="$(python -m site --user-base)/bin"
BIN_DIR=~/Binaries/bin
if [ ! -e ${PY_DIR}/pip ] ; then
    echo "Installing pip..."
    if ! curl -s -O https://bootstrap.pypa.io/get-pip.py ; then
        echo "Error downloading get-pip.py!"
        exit 1
    fi
    python get-pip.py --user
    rm -f get-pip.py
    if [ ! -x ${PY_DIR}/pip ] ; then
        echo "Can't find pip after installation!"
        exit 1
    fi
fi
if ! ${PY_DIR}/pip freeze|grep -q virtualenv ; then
    export PATH=$PY_DIR:$BIN_DIR:$PATH
    echo "Installing virtualenv..."
    if ! pip install --user virtualenv &>/dev/null ; then
        echo "Error installing virtualenv!"
        exit 1
    fi
fi
if [ ! -d ~/.venvs/ansible ] ; then
    mkdir ~/.venvs && virtualenv ~/.venvs/ansible
fi
if ! ~/.venvs/ansible/bin/pip freeze | grep -q ansible ; then
    echo "Installing ansible..."
    if ! ~/.venvs/ansible/bin/pip install ansible &>/dev/null ; then
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
pushd ${BASE}/ansible &>/dev/null
~/.venvs/ansible/bin/ansible-playbook -i hosts config.yml
popd &>/dev/null
