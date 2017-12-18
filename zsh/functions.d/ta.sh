ta(){
    if [ -z "$1" ] ; then
        return
    fi
    if [ -n "$TMUX" ] ; then
        tmux switch-client -t $1
        return
    fi
    tmux attach -t $1
}
