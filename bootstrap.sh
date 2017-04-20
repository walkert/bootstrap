#!/bin/bash

BASE=$(cd $(dirname $0); pwd)
PY_DIR="$(python -m site --user-base)/bin"
LOCAL_PIP=$(which pip 2>/dev/null)
export PATH=${PY_DIR}:$PATH

# Check pre-reqs are installed
SHARED_REQS="make fontconfig unzip"
if [ -e /etc/redhat-release ] ; then
    PKG="rpm -q"
    REQS="${SHARED_REQS} python-devel openssl-devel ncurses-devel libevent-devel"
else
    PKG="dpkg -L"
    REQS="${SHARED_REQS} python-dev libssl-dev libncurses5-dev libevent-dev"
fi

if ! $PKG cc &>/dev/null && ! $PKG gcc &>/dev/null ; then
    echo "You must install a compiler"
    exit 1
fi
quit=0
for req in $REQS ; do
    if ! $PKG $req &>/dev/null ; then
        quit=1
        echo "You must install $req"
    fi
done
if [ $quit -eq 1 ] ; then
    exit 1
fi

# Get pip if required
if [ -z "$LOCAL_PIP" ] ; then
    LOCAL_PIP="${PY_DIR}/pip"
    if [ ! -e $LOCAL_PIP ] ; then
        echo "Installing pip..."
        if ! curl -s -O https://bootstrap.pypa.io/get-pip.py ; then
            echo "Error downloading get-pip.py!"
            exit 1
        fi
        python get-pip.py --user
        rm -f get-pip.py
        if [ ! -x $LOCAL_PIP ] ; then
            echo "Can't find pip after installation!"
            exit 1
        fi
    fi
fi
if ! $LOCAL_PIP freeze|grep -q virtualenv ; then
    echo "Installing virtualenv..."
    if ! $LOCAL_PIP install --user virtualenv &>/dev/null ; then
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
