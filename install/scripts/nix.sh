#!/bin/bash
#
# Name: nix.sh
# Desc: Setup Nix

. ${1}/vars.sh
. ${1}/common.sh

# Check if /nix exists and if not, install/setup
if ! [ -d /nix ] ; then
    echo "Installing Nix..."
    sh <(curl -L https://nixos.org/nix/install) --daemon
fi
# Setup profiles
if [ ! -d ${NIX_PROF_DIR} ] ; then
    mkdir -p ${NIX_PROF_DIR}
fi
if [ -d ${NIX_CORE} ] ; then
    echo "${NIX_CORE} already configured. Exiting early."
    exit
fi
# Add the core path to the front before going any further
eval $(update_path)
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
# Set the 'core' profile during installation. This is where all core
# packages will be installed
nix-env --switch-profile ${NIX_CORE}
# If we don't have flakes - install via nix-env 
if nix flake 2>&1 | grep -q "not recognised" ; then
    for pkg in "${nix_env_packages[@]}" ; do
        nix-env -iA nixpkgs.${pkg}
    done
else
    if ! [ -e ${HOME}/.config/nix/nix.conf ] ; then
        mkdir -p ~/.config/nix
        cat > ${HOME}/.config/nix/nix.conf <<-EOF
		experimental-features = nix-command flakes
		EOF
    fi
    echo "installing from ${1}/nix"
    nix profile install ${1}/../nix
fi
# Now, switch profile to one for the user. This is where non-core packages
# will be installed
nix-env --switch-profile ${NIX_USER_PROFILE}
