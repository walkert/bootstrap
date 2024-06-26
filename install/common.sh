#!/bin/bash

# Some global vars
NIX_PROF_DIR="${HOME}/.local/state/nix/profiles"
NIX_CORE="${NIX_PROF_DIR}/core"
NIX_USER_PROFILE="${NIX_PROF_DIR}/${USER}"

set_nix_path(){
    echo "export PATH=${NIX_CORE}/bin:$PATH"
}

os_type(){
    echo $(uname -s|tr [:upper:] [:lower:])
}

is_linux(){
    if [ $(uname -s) = "Linux" ] ; then
        return 0
    fi
    return 1
}

is_mac(){
    if [ $(uname -s) = "Darwin" ] ; then
        return 0
    fi
    return 1
}

is_m1(){
    if [ $(uname -m) = "arm64" ] ; then
        return 0
    fi
    return 1
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

update_apt(){
    if is_redhat || is_mac ; then
        return 0
    fi
    # Max update is 1 week
    local max=$((24 * 7 * 60 * 60))
    local now=$(date +%s)
    local updated=$(stat -c %Y /var/cache/apt)
    local last=$((now - updated))
    local cmd="apt-get update"
    if [ $last -gt $max ] ; then
        echo "Updating apt cache"
        if ! is_root ; then
            cmd="sudo $cmd"
        fi
        run "$cmd"
    else
        return
    fi
}

install_pkg(){
    if is_mac ; then
        return 0
    fi
    if is_redhat ; then
        inst="yum -y install"
    else
        export DEBIAN_FRONTEND=noninteractive
        inst="apt-get install -y"
    fi
    if ! is_root ; then
        inst="sudo -E $inst"
    fi
    echo "Installing $@"
    update_apt
    run "$inst $*"
}

run(){
    local command=$1
    local fail=$2
    fail=${fail:="no_fail"}
    local print=$3
    _run "$command" $fail "noout"
}


check(){
    local command=$1
    local fail=$2
    fail=${fail:="no_fail"}
    _run "$command" $fail "print"
}

_run(){
    local command=$1
    local fail=$2
    local print=$3
    local output
    output=$($command 2>&1)
    if [ $? -ne 0 ] ; then
        if [ "$fail" = "fail_ok" ] ; then
            return 1
        fi
        echo "Error running command '${command}'"
        echo -e "Error text:\n${output}"
	    exit 1
    fi
    if [ "$print" = "print" ] ; then
        echo "$output"
    fi
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
        if ! ln -s $source $dest ; then
            echo "Error during symlink creation"
        fi
    fi
}
