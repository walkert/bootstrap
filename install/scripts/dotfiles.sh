#!/bin/bash
#
# Name: dotfile.sh
# Desc: Symlink dotfiles and generate .localrc

. ${1}/vars.sh
. ${1}/common.sh

for dot in $(find ${1}/../dotfiles -type f) ; do
    fname=$(basename $dot)
    dest="${HOME}/$fname"
    if [ -e $dest ] && [ ! -L $dest ] ; then
        mv $dest{,.orig}
    fi
    if [ -L $dest ] ; then
        continue
    fi
    ensure_link $dot $dest
done


if [ -e ${localrc} ] ; then
    exit
fi
myenv=$(dirname $1)
cat > ${localrc} <<EOF
# Set MYENV (the location of the gitrepo)
export MYENV=$myenv

# Set LOCAL_BIN - the location where 'user' python binaries are installed
export LOCAL_BIN=$bin_dir
EOF

if is_m1 ; then
    cat >> ${localrc} <<-EOF
	export PATH=$PATH
	EOF
fi
if ! is_linux ; then
    exit
fi

# Determine where brew is installed
if [ -d ~/.linuxbrew ] ; then
    brew=~/.linuxbrew/bin/brew
else
    brew=/home/linuxbrew/.linuxbrew/bin/brew
fi
cat >> ${localrc} <<EOF

# Setup Brew
$($brew shellenv 2>/dev/null)
EOF
