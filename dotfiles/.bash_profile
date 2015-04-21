# .bashrc

# Source definitions in /etc followed by ~/.localrc
for file in /etc/bashrc ~/.localrc ; do
    if [ -f $file ] ; then
        . $file
    fi
done

# User specific aliases and functions

# Set VI mode
set -o vi

# Global variables
MYENV=${MYENV:-~/.bootstrap}
DOTFILES=${MYENV}/dotfiles
LOCAL_BIN=${LOCAL_BIN:-~/.local/bin}
export GOROOT=~/Binaries/go
export GOPATH=~/Go

# Update PATH
export PATH=${LOCAL_BIN}:${GOROOT}/bin:$PATH
# Override READLINE default
export INPUTRC=${DOTFILES}/.inputrc
# Explicitly set TERM to linux
export TERM=linux

# Configure aliases
alias ipython='ipython --autocall=1'
alias j='jobs'
alias noh='ssh -o StrictHostKeyChecking=no -l root -A -o UserKnownHostsFile=/dev/null'
alias ncp='scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

# Source virtualenvwrapper
VWRAPPER="${LOCAL_BIN}/virtualenvwrapper.sh"
if [ -f $VWRAPPER ] ; then
    export WORKON_HOME=~/.venvs
    . $VWRAPPER
fi

# Source functions
FUNCTIONS="${MYENV}/bash/functions.d"
if [ -d $FUNCTIONS ] ; then
    for f in $(ls $FUNCTIONS) ; do
        . ${FUNCTIONS}/f
    done
fi

# Bash completion
LINUX_COMPLETION="/etc/profile.d/bash_completion.sh"
BREW_COMPLETION="/usr/local/etc/bash_completion"
MYENV_COMPLETION="${MYENV}/bash/bash_completion"
if [ -f $LINUX_COMPLETION ] ; then
    . $LINUX_COMPLETION
elif [ -f $BREW_COMPLETION ] ; then
    . $BREW_COMPLETION
else
    export BASH_COMPLETION_DIR=${MYENV_COMPLETION}.d
    export BASH_COMPLETION_COMPAT_DIR=$BASH_COMPLETION_DIR
    . $MYENV_COMPLETION
fi
