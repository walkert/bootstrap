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

is_root(){
    if [ "$(id -un)" = "root" ] ; then
        return 0
    fi
    return 1
}

is_installed(){
    if is_redhat ; then
        chk="rpm -q"
    else
        chk="dpkg -l"
    fi
    if $chk | grep -q $1 ; then
        return 0
    fi
    return 1
}

install_pkg(){
    if is_redhat ; then
        inst="yum -y install"
    else
        inst="apt-get install -y"
    fi
    if ! is_root ; then
        inst="sudo $inst"
    fi
    for pkg in $@ ; do
        if ! is_installed $pkg ; then
            $inst $pkg &>/dev/null
        fi
    done
}

install_devel(){
    install_pkg "${devel_packages[@]}"
}
