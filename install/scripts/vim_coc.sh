#!/bin/bash
#
# Name: vim_coc.sh
# Desc: Setup coc.nvim

. ${1}/vars.sh
. ${1}/common.sh

plugin="coc.nvim"
bundle_dir="${HOME}/.vim/bundle/coc.nvim"
node="${binaries_dir}/node"
branch="release"
config_dest="${HOME}/.vim/coc-settings.json"
config_source="${1}/misc/coc-settings.json"

install_node(){
    ensure_dir ${node}
    if ! curl -sL install-node.now.sh/lts | bash -s -- --prefix=${node} --force &>/dev/null ; then
        echo "Unable to install node"
        exit 1
    fi
    ensure_link ${node}/bin/node ${bin_dir}/node
    ensure_link ${node}/bin/npm ${bin_dir}/npm
}

if [ ! -d $node ] ; then
    install_node
fi
if [ ! -e ${config_dest} ] ; then
    ln -s ${config_source} ${config_dest}
fi
if [ -d ${bundle_dir} ] ; then
    cd ${bundle_dir}
    if ! git rev-parse --abbrev-ref HEAD | grep -q ${branch} ; then
        run "git checkout -t origin/${branch}"
    fi
fi
# Install extensions
mkdir -p ~/.config/coc/extensions
cd ~/.config/coc/extensions
if [ ! -f package.json ]
then
  echo '{"dependencies":{}}'> package.json
fi
export PATH=${PATH}:${bin_dir}
for plugin in "${vim_coc_plugins[@]}" ; do
    run "npm install ${plugin} --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod"
done
# Install flake8 and jedi for python
export PATH="${HOME}/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
run "pip install --user ${vim_coc_pip[*]}"

# Install Go binaries for vim-go
vim="/home/linuxbrew/.linuxbrew/bin/vim"
export GOPATH=${HOME}/Go
export PATH="${HOME}/Binaries/bin:${HOME}/Binaries/go/bin:$PATH"
echo "  Installing vim-go binaries.."
$vim +'silent :GoInstallBinaries' +qall
