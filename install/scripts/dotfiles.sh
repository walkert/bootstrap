#!/bin/bash
#
# Name: dotfile.sh
# Desc: Symlink dotfiles and generate .localrc

. ${1}/vars.sh

for dot in $(find ${1}/../dotfiles -type f) ; do
    fname=$(basename $dot)
    dest="${HOME}/$fname"
    if [ -e $dest ] && [ ! -L $dest ] ; then
        mv $dest{,.orig}
    fi
    if [ -L $dest ] ; then
        continue
    fi
    ln -s $dot $dest
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

# Set VIRTUALENVWRAPPER_PYTHON
export VIRTUALENVWRAPPER_PYTHON=${virtualenv_dir}/virtualenvwrapper/bin/python
EOF
