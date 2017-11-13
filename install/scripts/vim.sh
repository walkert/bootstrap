#!/bin/bash
#
# Name: vim.sh
# Desc: Install a lua/python-enabled vim (if required) and get Vundle plugins

. ${1}/vars.sh
. ${1}/common.sh

install_lua(){
    set -e
    if is_redhat ; then
        install_pkg "${lua_reqs_red[@]}"
    else
        install_pkg "${lua_reqs_deb[@]}"
    fi
    local lua_tmp=$(mktemp -d)
    local lua_file="lua.tgz"
    wget -O $lua_file $lua_tar &>/dev/null
    tar -C $lua_tmp --strip 1 -xzf $lua_file &>/dev/null
    cd $lua_tmp
    make linux test &>/dev/null
    make install INSTALL_TOP=${binaries_dir}/lua &>/dev/null
    cd - &>/dev/null
    rm -rf $lua_file $lua_tmp
    set +e
}

install_vim(){
    set -e
    local vim_tmp=$(mktemp -d)
    git clone $vim_repo $vim_tmp &>/dev/null
    cd $vim_tmp
    ./configure --enable-pythoninterp --enable-luainterp --with-lua-prefix=${binaries_dir}/lua --prefix=${binaries_dir}/vim &>/dev/null
    make &>/dev/null
    make install &>/dev/null
    cd - &>/dev/null
    rm -rf $vim_tmp
    set +e
}

vim="${binaries_dir}/vim/bin/vim"
bundle_dir=$(dirname $vundle_dir)
if [ ! -d $bundle_dir ] ; then
    mkdir -p $bundle_dir
fi
if [ ! -e $vundle_dir ] ; then
    git clone $vundle $vundle_dir &>/dev/null
fi
if which vim &>/dev/null ; then
    version=$(vim --version)
    if grep -q '+python' <<< "$version" && grep -q '+lua' <<< "$version" ; then
        $vim +PluginInstall +qall &>/dev/null
        exit
    fi
fi
install_devel
echo "Installing vim with lua/python support..."
install_lua
install_vim
ln -s ${vim} ${bin_dir}/vim
$vim +PluginInstall +qall &>/dev/null
