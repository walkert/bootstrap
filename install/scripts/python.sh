#!/bin/bash
#
# Name: python.sh
# Desc: Create a virtualenv for each entry in $python_packages

. ${1}/vars.sh
. ${1}/common.sh

if is_redhat ; then
    install_pkg "${python_reqs_red[@]}"
else
    install_pkg "${python_reqs_deb[@]}"
fi
for i in $(seq 0 ${#python_packages[@]}) ; do
    pkg=${python_packages[$(($i-1))]}
    bin=${python_package_links[$(($i-1))]}
    vdir=${virtualenv_dir}/${pkg}
    link_source=${vdir}/bin/${bin}
    link_dest=${bin_dir}/${bin}
    if [ ! -d ${vdir} ] ; then
        run "virtualenv ${vdir}"
        run "${vdir}/bin/pip install $pkg"
    fi

    if [ ! -L $link_dest ] ; then
        ln -s $link_source $link_dest
    fi
done
