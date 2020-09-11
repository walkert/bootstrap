#!/bin/bash
#
# Name: rust.sh
# Desc: Install Rust

. ${1}/vars.sh
. ${1}/common.sh

CARGO_DIR="${HOME}/.cargo/bin"


if [ -d ${CARGO_DIR} ] ; then
    echo "Attempting to update Rust.."
    run "${CARGO_DIR}/rustup update"
    exit 0
fi

echo "  Installing Rust.."
if ! curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- --no-modify-path -y --profile default >/dev/null 2>&1 ; then
    echo "Unable to install Rust"
    exit 1
fi
