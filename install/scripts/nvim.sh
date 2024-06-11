#!/bin/bash
#
# Name: nvim.sh
# Desc: Install a neovim and setup packer

. ${1}/vars.sh
. ${1}/common.sh

eval $(set_nix_path)

pack_dir=~/.config/nvim/pack/packer/start

export GOROOT=~/Binaries/go
export GOPATH=~/Go
export PATH=$PATH:${GOROOT}/bin

if [ ! -d ${pack_dir} ] ; then
    echo "Setting up Packer"
    run "git clone --depth 1 https://github.com/wbthomason/packer.nvim ${pack_dir}/packer.nvim"
    nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
    echo "Installing Go Binaries"
    nvim --headless -c 'PackerLoad vim-go' -c 'silent :GoInstallBinaries' +qall
fi
