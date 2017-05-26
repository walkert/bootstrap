# .zshrc

# Source definitions in /etc followed by ~/.localrc
for file in /etc/zshrc ~/.localrc ; do
    if [ -f $file ] ; then
        . $file
    fi
done

# Global variables
export MYENV=${MYENV:-~/.bootstrap}
export LOCAL_BIN=${LOCAL_BIN:-~/.local/bin}

export TERM=screen-256color

# GO
export GOROOT=~/Binaries/go
export GOPATH=~/Go

# Update PATH to include bin locations
export PATH=${LOCAL_BIN}:${GOROOT}/bin:${GOPATH}/bin:$PATH

# Set CDATH
export CDPATH=$HOME:.

# Configure aliases
alias ipython='ipython --autocall=1'
alias j='jobs'
alias noh='ssh -o StrictHostKeyChecking=no -l root -A -o UserKnownHostsFile=/dev/null'
alias ncp='scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias vi='vim'
if [ $(uname -s) = "Darwin" ] ; then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi

# History
export HISTFILE=~/.zhistfile
export HISTFILESIZE=1000000
export SAVEHIST=1000000

# All sessions will append to the history as they exit
setopt appendhistory 
# Save command timestamp history
setopt extended_history
# Don't write duplicates to the history
setopt hist_ignore_dups
# Disable Flowcontrol
setopt NOFlowControl
# Record time taken for commands
setopt incappendhistorytime
# Use HISTORY_IGNORE to drop patters from the history
HISTORY_IGNORE="(ls|bg|fg|history|jobs|j|ta|tap)"
# Modify the zshaddhistory hook to prevent ignored entries hitting the current history
zshaddhistory() {
    setopt extendedglob
    emulate -L zsh
    [[ ${1%%$'\n'} != ${~HISTORY_IGNORE} ]]
}

# Misc options
# Switch to paths without 'cd'
setopt autocd 
# Don't warn if shell patterns have no matches
setopt nonomatch

# Source virtualenvwrapper
VWRAPPER="${LOCAL_BIN}/virtualenvwrapper.sh"
if [ -f $VWRAPPER ] ; then
    export WORKON_HOME=~/.venvs
    . $VWRAPPER
fi

# Completions
export FPATH="${MYENV}/zsh/completions.d:$FPATH"
export CACHEDIR="$HOME/.zsh/cache"
autoload -U compinit
compinit -d $CACHEDIR/zcompdump 2>/dev/null
# Use bash completions
autoload bashcompinit
bashcompinit

# Source functions
FUNCTIONS="${MYENV}/zsh/functions.d"
if [ -d $FUNCTIONS ] ; then
    for f in $(ls $FUNCTIONS) ; do
        . ${FUNCTIONS}/$f
    done
fi

# Vim key bindings
setopt interactivecomments
bindkey -v
bindkey "^?" backward-delete-char
bindkey "^W" backward-kill-word
# Start typing a word, hit 'jk' and the line will fill from the backwards search
bindkey "jk" history-beginning-search-backward
# "ji" for reverse incremental search.
bindkey "ji" history-incremental-search-backward
# "jj" to command mode
bindkey -M viins "jj" vi-cmd-mode
# Replicate escape-k in bash vi-mode - cursor at the beginning
bindkey -M vicmd k vi-up-line-or-history
# Exit incremental search and allow editing of the returned line
bindkey "^A" accept-search
# Put the current command line in an editor
bindkey "^E" edit-command-line
autoload -U edit-command-line
zle -N edit-command-line

# Completion stuff
# Cache stuff
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $CACHEDIR/cache
# Print menu for multiple options
zstyle ':completion:*' menu select
# Descriptions
zstyle ':completion:*:descriptions' format '%U%F{blue}%d%u%f'
# Format warnings
zstyle ':completion:*:warnings' format '%U%B%F{red}Sorry, no matches for: %d%b%u%f'
# Colour for files
zstyle ':completion:*' list-colors ''
# Case-insensitive matching
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'l:|=* r:|=*'
# Hosts completion (this file should contain hostnames you care about)
zstyle -e ':completion:*:*:*' hosts 'reply=($(awk "/^[1-9]/{print $NF}" /etc/hosts))'
# To add hosts completion to custom commands
# compdef _hosts <custom command>

# Prompt
# Allow shell expansion
setopt prompt_subst
# Git fun
# Enable the vcs_info function
autoload -Uz vcs_info
# Set the strings for [un]staged files
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '%F{yellow}●%f'
zstyle ':vcs_info:*' unstagedstr '%F{green}●%f'
precmd(){
    # Set the prompt to check for untracked files as well
    if [[ -z $(git ls-files --other --exclude-standard 2>/dev/null) ]] ; then
        zstyle ':vcs_info:git*' formats "%F{yellow}%b%f%c%u"
        zstyle ':vcs_info:git*' actionformats "%F{yellow}%b%f%c%u|%F{red}%a%f"
    else
        zstyle ':vcs_info:git*' formats "%F{yellow}%b%f%c%u%F{cyan}●%f"
        zstyle ':vcs_info:git*' actionformats "%F{yellow}%b%f%c%u%F{cyan}●%f|%F{red}%a%f"
    fi
    vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && vcs_info_msg_0_="[${vcs_info_msg_0_}]"
}
PROMPT='%n@%m:%~${vcs_info_msg_0_}$ '

# Random
#Use 'bash' style word style to delete-backwards observation of / delimiters
autoload -U select-word-style
select-word-style bash

# Overrides
# Source ~/.overrides.shell if it exits. This file should contain anything that can't be applied
# in ~/.localrc such as changes to PATH/zstyle etc
if [ -f ~/.overrides.shell ] ; then
    . ~/.overrides.shell
fi

# Start in tmux by default
if [ -z $TMUX ] ; then
    tmux a -t home >/dev/null 2>&1 || tmux new -s home
fi
