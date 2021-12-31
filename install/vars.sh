base_packages_all=(curl wget git unzip gcc fontconfig make)
base_packages_ubuntu=(build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl)
base_packages_redhat=(ruby zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel xz xz-devel libffi-devel findutils libxcrypt-compat)
minimal_scripts=(vim.sh vim_coc.sh)
python_version=3.9.6
python_packages=(ipython)
virtualenv_dir="${HOME}/.venvs"
binaries_dir="${HOME}/Binaries"
bin_dir="${HOME}/Binaries/bin"
localrc="${HOME}/.localrc"
create_dirs=("$virtualenv_dir" "$bin_dir")
tmux_plugins=(https://github.com/tmux-plugins/tpm)
tmux_brew_packages=(tmux)
brew_packages=(fzf ripgrep vim wget)
go_url="https://storage.googleapis.com/golang"
fonts_expect=(Hack-Regular.ttf)
fonts_dl=(https://github.com/chrissimpkins/Hack/releases/download/v2.020/Hack-v2_020-ttf.zip)
vim_coc_plugins=(coc-pyright coc-rls)
vim_coc_pip=(jedi flake8)
vundle="https://github.com/VundleVim/Vundle.vim.git"
vundle_dir="${HOME}/.vim/bundle/Vundle.vim"
zsh_extras=(https://github.com/zsh-users/zsh-autosuggestions https://github.com/zsh-users/zsh-syntax-highlighting https://github.com/romkatv/powerlevel10k)
