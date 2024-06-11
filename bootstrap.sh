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

# Base packages, required for Nix installation to work
echo "Checking base packages.."
install_pkg "${base_packages_all[@]}"
if [ "$1" = "minimal" ] ; then
    echo "Performing minimal install.."
    run_scripts "${minimal_scripts[@]}"
    exit 0
fi
run_scripts $(ls ${BASE}/install/scripts)
