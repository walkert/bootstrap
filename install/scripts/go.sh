#!/bin/bash
#
# Name: go.sh
# Desc: Install Go

. ${1}/vars.sh
. ${1}/common.sh

install_go(){
    local gofile="go.tgz"
    run "wget -O $gofile $go_dl"
    run "tar -C $binaries_dir -xzf $gofile"
    run "rm -rf $gofile"
}

godir="${binaries_dir}/go"
go="${godir}/bin/go"
go_tar="go${go_version}.$(os_type)-amd64.tar.gz"
go_dl="${go_url}/${go_tar}"

if [ -e $go ] ; then
    if ! check "$go version" | grep -q $go_version ; then
        run "rm -rf $godir"
    else
        exit 0
    fi
fi
echo "Installing Go.."
install_go
