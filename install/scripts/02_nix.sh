#!/bin/bash
#
# Name: nix.sh
# Desc: Setup Nix

. ${1}/vars.sh
. ${1}/common.sh

# Check if /nix exists and if not, install/setup
if ! [ -d /nix ] ; then
    echo "Installing Nix..."
    sh <(curl -L https://nixos.org/nix/install) --daemon --yes
fi
# Setup profiles
if [ ! -d ${NIX_PROF_DIR} ] ; then
    mkdir -p ${NIX_PROF_DIR}
fi
# Add the core path to the front before going any further
eval "$(set_nix_path)"
# Eval fails on the mac if paths have a space in them when 'set -e'
# is enabled, so set it after.
set -e
if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi
# During installation, make sure to start nix-daemon
# root can run using sudo and we'll assume we have sudo access
# as well...
if ! pgrep -q nix-daemon; then
    echo "Starting nix-daemon.."
    nohup sudo $(which nix-daemon) &
fi
# Capture the location of nix-env (symlink to 'nix' prior to profile switch
current_nix_env="$(dirname $(readlink -f $(which nix-env)))/nix-env"
run "nix-channel --update"
# Set the 'core' profile during installation. This is where all core
# packages will be installed
nix-env --switch-profile ${NIX_CORE}
# Once upon a time I tried this with a flake but the process for
# updating them and viewing their contents was inconsistent.
# So, we stick with the profiles, but just use a basic nix file
# to install packages. Call with replace to always install the latest
# version of a package. We'll deal with the problems this may bring
# if and when that happens..
${current_nix_env} -irf ${1}/../nix/packages.nix
# Now, switch profile to one for the user. This is where non-core packages
# will be installed
${current_nix_env} --switch-profile ${NIX_USER_PROFILE}
