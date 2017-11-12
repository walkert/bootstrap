#!/bin/bash

os_type(){
    echo $(uname -s|tr [:upper:] [:lower:])
}

is_redhat(){
    if [ -e /etc/redhat-release ] ; then
        return 0
    fi
    return 1
}

install_pkg(){
    set -e
    if is_redhat ; then
        chk="rpm -q"
        inst="yum -y install"
    else
        chk="dpkg -L"
        inst="apt-get install -y"
    fi
    for pkg in ${1[*]} ; do
        if ! $chk $1 &>/dev/null ; then
            sudo $inst $1 &>/dev/null
        fi
    done
    set -e
}

install_devel(){
    install_pkg $devel_packages
}
