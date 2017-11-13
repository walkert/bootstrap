#!/bin/bash
#
# Name: vim.sh
# Desc: Install a lua/python-enabled vim (if required) and get Vundle plugins

. ${1}/vars.sh
. ${1}/common.sh

install_lua(){
    if is_redhat ; then
        install_pkg "${lua_reqs_red[@]}"
    else
        install_pkg "${lua_reqs_deb[@]}"
    fi
    local lua_tmp=$(mktemp -d)
    local lua_file="lua.tgz"
    run "wget -O $lua_file $lua_tar"
    run "tar -C $lua_tmp --strip 1 -xzf $lua_file"
    cd $lua_tmp
    run "make linux test"
    run "make install INSTALL_TOP=${binaries_dir}/lua"
    cd - &>/dev/null
    run "rm -rf $lua_file $lua_tmp"
}

install_vim(){
    local vim_tmp=$(mktemp -d)
    run "git clone $vim_repo $vim_tmp"
    cd $vim_tmp
    run "./configure --enable-pythoninterp --enable-luainterp --with-lua-prefix=${binaries_dir}/lua --prefix=${binaries_dir}/vim"
    run "make"
    run "make install"
    cd - &>/dev/null
    run "rm -rf $vim_tmp"
}

vim="${binaries_dir}/vim/bin/vim"
bundle_dir=$(dirname $vundle_dir)
if [ ! -d $bundle_dir ] ; then
    mkdir -p $bundle_dir
fi
if [ ! -e $vundle_dir ] ; then
    run "git clone $vundle $vundle_dir"
fi
if which vim &>/dev/null ; then
    version=$(check "vim --version")
    if grep -q '+python' <<< "$version" && grep -q '+lua' <<< "$version" ; then
        run "$vim +PluginInstall +qall"
        exit
    fi
fi
install_devel
echo "Installing vim with lua/python support..."
install_lua
install_vim
ln -s ${vim} ${bin_dir}/vim
run "$vim +PluginInstall +qall"
