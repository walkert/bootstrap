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
install_pkg "${base_packages_all[@]}"
if is_redhat ; then
    install_pkg "${base_packages_redhat[@]}"
    if is_root ; then
        yum -y groupinstall 'Development Tools' 2>&1 >/dev/null
    else
        sudo yum -y groupinstall 'Development Tools' 2>&1 >/dev/null
    fi
else
    install_pkg "${base_packages_ubuntu[@]}"
fi

install_homebrew="false"
# Make sure xcode CLI tools are setup and install Homebrew
if is_mac ; then
    xcode=$(xcode-select --install 2>&1)
    if [ $? -ne 0 ] ; then
        if ! grep -q "already installed" <<< "$xcode" ; then
            echo "Unexpected error from xcode-install"
            exit 1
        fi
    fi
    if [ ! -x "$(brew_path)/brew" ] ; then
        install_homebrew="true"
    fi
    if is_m1 ; then
        export PATH=$(brew_path):$PATH
    fi
else
    if [ ! -d ~/.linuxbrew ] && [ ! -d /home/linuxbrew/.linuxbrew ] ; then
        install_homebrew="true"
    fi
fi
if [ "${install_homebrew}" = "true" ] ; then
    export CI=true
    echo "Installing Homebrew"
    if ! bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" >/dev/null 2>&1 ; then
        echo "Unable to install Homebrew"
        exit 1
    fi
fi
run_scripts $(ls ${BASE}/install/scripts)
