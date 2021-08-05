#!/bin/bash
#
# Name: python.sh
# Desc: Create a virtualenv for each entry in $python_packages

. ${1}/vars.sh
. ${1}/common.sh

if [ ! -d ~/.pyenv ] ; then
    if is_linux ; then
        if ! sh -c "$(curl -s -S -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer)" >/dev/null 2>&1 ; then
            echo "Unable to install pyenv"
            exit 1
        fi
    fi
    if is_mac ; then
        brew_install pyenv pyenv-virtualenv
    fi
fi

export PATH="~/.pyenv/shims:$PATH"
eval "$(pyenv init -)"

if ! pyenv versions | grep -q ${python_version} ; then
    echo "  Installing Python ${python_version} via pyenv"
    if ! run "pyenv install ${python_version}" ; then
        echo "Unable to install Python {python_version}"
        exit 1
    fi
    pyenv global ${python_version}
fi

if ! run "which pipx" "fail_ok" ; then
    echo "  Installing pipx"
    run "pip install pipx"
fi

export PIPX_BIN_DIR=${bin_dir}
for pkg in "${python_packages[@]}" ; do
    if [ ! -d ${HOME}/.local/pipx/venvs/${pkg} ] ; then
        echo "  Installing ${pkg} via pipx"
        run "pipx install ${pkg}"
    fi
done
