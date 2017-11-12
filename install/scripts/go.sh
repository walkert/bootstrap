#!/bin/bash

. ${1}/vars.sh
. ${1}/common.sh

install_go(){
    set -e
    local gofile="go.tgz"
    wget -O $gofile $go_dl &>/dev/null
    tar -C $binaries_dir -xzf $gofile &>/dev/null
    rm -rf $gofile
    set +e
}

godir="${binaries_dir}/go"
go="${godir}/bin/go"
go_tar="go${go_version}.$(os_type)-amd64.tar.gz"
go_dl="${go_url}/${go_tar}"

if [ -e $go ] ; then
    if ! go version | grep -q $go_version ; then
        rm -rf $godir
    else
        exit
    fi
fi
echo "Installing Go.."
install_go
