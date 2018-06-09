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
export COMPLETIONS="${MYENV}/zsh/completions.d"
export FUNCTIONS="${MYENV}/zsh/functions.d"

export TERM=screen-256color

# GO
export GOROOT=~/Binaries/go
export GOPATH=~/Go

# Update PATH to include bin locations
export PATH=${LOCAL_BIN}:${GOROOT}/bin:${GOPATH}/bin:$PATH

# Update fpath to include custom completions and functions
fpath+=($FUNCTIONS $COMPLETIONS)

# Set CDATH
export CDPATH=$HOME:.

# Configure aliases
alias ipython='ipython --autocall=1'
alias j='jobs'
alias noh='ssh -o StrictHostKeyChecking=no -l root -A -o UserKnownHostsFile=/dev/null'
alias ncp='scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias vi='vim'
if [ $(uname -s) = "Darwin" ] ; then
    is_mac=1
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
# Allow comments in commands i.e $ date # this is a comment
setopt interactivecomments

# Source virtualenvwrapper
VWRAPPER="${LOCAL_BIN}/virtualenvwrapper.sh"
if [ -f $VWRAPPER ] ; then
    export WORKON_HOME=~/.venvs
    . $VWRAPPER
fi

# Completions
autoload -U compinit
compinit
# Use bash completions
autoload bashcompinit
bashcompinit

# Source functions
if [ -d $FUNCTIONS ] ; then
    for f in $(ls ${FUNCTIONS}/*.sh) ; do
        . $f
    done
fi

# Load custom history search
autoload -U history-search-cmd
zle -N history-beginning-search-forward-cmd history-search-cmd
zle -N history-beginning-search-backward-cmd history-search-cmd

# Vim key bindings
bindkey -v
bindkey "^?" backward-delete-char
bindkey "^W" backward-kill-word
# Start typing a word, hit 'Ctrl-k' and the line will fill from a backwards search
# The 'search-start' widget goes into vi-cmd-mode so we update the vicmd map to
# use Ctrl-k as well - including regular 'k'.
bindkey "" history-beginning-search-backward-cmd
bindkey -M vicmd "" history-beginning-search-backward-cmd
bindkey -M vicmd "k" history-beginning-search-backward-cmd
# Once searching backwards, Ctrl-j goes forward - same rules as above
bindkey "^j" history-beginning-search-forward-cmd
bindkey -M vicmd "^j" history-beginning-search-forward-cmd
bindkey -M vicmd "j" history-beginning-search-forward-cmd
# "Ctrl-r" for reverse incremental search.
bindkey "" history-incremental-search-backward
# "jj" to command mode
bindkey -M viins "jj" vi-cmd-mode
# Exit incremental search and allow editing of the returned line
bindkey "^A" accept-search
# Put the current command line in an editor
bindkey "^E" edit-command-line
autoload -U edit-command-line
zle -N edit-command-line

# Completion stuff
# Activate caching layer for completions that use it (use default cache-path)
zstyle ':completion:*' use-cache on
# Print menu for multiple options
zstyle ':completion:*' menu select
# Descriptions
zstyle ':completion:*:descriptions' format '%U%F{blue}%d%u%f'
# Format warnings
zstyle ':completion:*:warnings' format '%U%B%F{red}Sorry, no matches for: %d%b%u%f'
# Colour for files
zstyle ':completion:*' list-colors ''
# Set matching options, args are: case-insensitive matching, partial (mid-word)
# and expand short names to long so very.c -> veryverylongfile.c
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'l:|=* r:|=*' 'r:|[._-]=* r:|=*'
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
        zstyle ':vcs_info:*' formats "%F{yellow}%b%f%c%u"
        zstyle ':vcs_info:*' actionformats "%F{yellow}%b%f%c%u|%F{red}%a%f"
    else
        zstyle ':vcs_info:*' formats "%F{yellow}%b%f%c%u%F{cyan}●%f"
        zstyle ':vcs_info:*' actionformats "%F{yellow}%b%f%c%u%F{cyan}●%f|%F{red}%a%f"
    fi
    vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && vcs_info_msg_0_="[${vcs_info_msg_0_}]"
}
PROMPT='%n@%m:%~${vcs_info_msg_0_}$ '

# Random
#Use 'bash' style word style to delete-backwards observation of / delimiters
autoload -U select-word-style
select-word-style bash
# Set colors to solarized-dark
if [ -f ~/.dircolors ] ; then
    if [ -z "$is_mac" ] ; then
        eval $(dircolors ~/.dircolors)
    fi
fi

# zsh extras
if [ -d ~/.zsh ] ; then
    for extra in $(ls -d ~/.zsh/zsh* 2>/dev/null) ; do
        . ${extra}/$(basename ${extra}).zsh
    done
    # Ctrl-o executes the current suggestion
    bindkey '^O' autosuggest-execute
    # Change the default highlight colour
    export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=yellow'
fi

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
