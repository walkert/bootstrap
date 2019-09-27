#!/bin/bash
#
# Name: python.sh
# Desc: Create a virtualenv for each entry in $python_packages

. ${1}/vars.sh
. ${1}/common.sh

pkg_count=$((${#python_packages[@]} -1 ))
for i in $(seq 0 ${pkg_count}) ; do
    pkg=${python_packages[$(($i))]}
    bin=${python_package_links[$(($i))]}
    vdir=${virtualenv_dir}/${pkg}
    link_source=${vdir}/bin/${bin}
    link_dest=${bin_dir}/${bin}
    if ensure_dir ${vdir} ; then
        run "virtualenv ${vdir}"
        run "${vdir}/bin/pip install $pkg"
    fi

    ensure_link $link_source $link_dest
done
