#!/bin/bash

. ${1}/vars.sh
for i in $(seq 0 ${#python_packages[@]}) ; do
    pkg=${python_packages[$(($i-1))]}
    bin=${python_package_links[$(($i-1))]}
    vdir=${virtualenv_dir}/${pkg}
    link_source=${vdir}/bin/${bin}
    link_dest=${bin_dir}/${bin}
    if [ ! -d ${vdir} ] ; then
        virtualenv ${vdir}
        ${vdir}/bin/pip install $pkg &>/dev/null
    fi

    if [ ! -L $link_dest ] ; then
        ln -s $link_source $link_dest
    fi
done
