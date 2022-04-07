#!/bin/bash
#
# Name: nvim.sh
# Desc: Install a neovim and setup packer

. ${1}/vars.sh
. ${1}/common.sh

pack_dir=~/.config/nvim/pack/packer/start
nvim="$(brew_path)/nvim"

export GOROOT=~/Binaries/go
export GOPATH=~/Go
export PATH=$PATH:${GOROOT}/bin

for pkg in "${nvim_brew_packages[@]}" ; do
    brew_install $pkg
done

if [ ! -d ${pack_dir} ] ; then
    echo "Setting up Packer"
    run "git clone --depth 1 https://github.com/wbthomason/packer.nvim ${pack_dir}/packer.nvim"
    nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
    echo "Installing Go Binaries"
    nvim +'silent :GoInstallBinaries' +qall
fi

for pkg in "${nvim_node_packages[@]}" ; do
    run "npm i -g $pkg"
done
