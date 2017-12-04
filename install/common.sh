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
    local pkg=$1
    if is_redhat ; then
        if run "rpm -q $pkg" fail_ok ; then
            return 0
        fi
    else
        if check "apt-cache policy $pkg" fail_ok | grep Installed | grep -q -v none ; then
            return 0
        fi
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
            run "$inst $pkg"
        fi
    done
}

install_devel(){
    install_pkg "${devel_packages[@]}"
}

run(){
    local command=$1
    local fail=$2
    _run "$command" $fail >/dev/null
}


check(){
    local command=$1
    local fail=$2
    _run "$command" $fail
}

_run(){
    local command=$1
    local fail=$2
    local output
    output=$($command 2>&1)
    if [ $? -ne 0 ] ; then
        if [ "$fail" = "fail_ok" ] ; then
            return 1
        fi
        echo "Error running command '${command}'" > /dev/stderr
        echo -e "Error text:\n${output}" > /dev/stderr
	    exit 1
    fi
    echo "$output"
}

ensure_dir(){
    if [ ! -d $1 ] ; then
        run "mkdir -p $1"
        return 0
    fi
    return 1
}

ensure_link(){
    local source=$1
    local dest=$2
    if [ ! -L $dest ] ; then
        ln -s $source $dest
    fi
}
