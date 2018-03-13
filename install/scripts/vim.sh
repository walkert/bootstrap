#!/bin/bash
#
# Name: vim.sh
# Desc: Install a lua/python-enabled vim (if required) and get Vundle plugins

. ${1}/vars.sh
. ${1}/common.sh

install_lua(){
    if is_mac ; then
        return
    fi
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
    if is_mac ; then
        brew_install vim
        return
    fi
    local vim_tmp=$(mktemp -d)
    run "git clone $vim_repo $vim_tmp"
    cd $vim_tmp
    run "./configure --enable-pythoninterp --enable-luainterp --with-lua-prefix=${binaries_dir}/lua --prefix=${binaries_dir}/vim"
    run "make"
    run "make install"
    cd - &>/dev/null
    run "rm -rf $vim_tmp"
    ensure_link ${binaries_dir}/vim/bin/vim ${bin_dir}/vim
}

vim=("${binaries_dir}/vim/bin/vim")
bundle_dir=$(dirname $vundle_dir)
ensure_dir $bundle_dir
if [ ! -e $vundle_dir ] ; then
    run "git clone $vundle $vundle_dir"
fi
installed=$(which vim 2>/dev/null)
if [ -n "$installed" ] ; then
    vim+=($installed)
fi
for binary in ${vim[*]} ; do
    if [ ! -e $binary ] ; then
        continue
    fi
    version=$(check "$binary --version")
    if grep -q '+python' <<< "$version" && grep -q '+lua' <<< "$version" ; then
        run "$binary +PluginInstall +qall"
        exit
    fi
done
install_devel
echo "Installing vim with lua/python support..."
install_lua
install_vim
run "$vim +PluginInstall +qall"
