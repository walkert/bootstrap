function _virsh()
{
    # Generic setup
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    COMPREPLY=()
    _get_comp_words_by_ref cur prev

    # If any of our approved words are used, list the domains,
    # otherwise, list approved args until a valid domain has been chosen.
    case $prev in
        edit|start|stop|destroy)
            _get_domains
            return 0
        ;;
        *)
            if [[ $COMP_CWORD -eq 1 ]] ; then
                # compgen lists these words as options and narrows down what
                # it displays based on the current word/partial $cur.
                COMPREPLY=($(compgen -W 'edit destroy start stop' -- "$cur"))
            else
                # If we've now got our final argument and it's not hitting
                # the above case statement, re-display the available opts.
                _get_domains
            fi
        ;;
    esac
}

function _get_domains()
{
    files=$(ls /etc/libvirt/qemu/*.xml 2>/dev/null)
    if [ -n "$files" ] ; then
        for file in $files ; do
            file=$(basename $(echo $file | cut -d. -f1))
            COMPREPLY=( ${COMPREPLY[@]} $file )
        done
    fi
    COMPREPLY=($(compgen -W '${COMPREPLY[@]}' -- "$cur" ))
}
complete -F _virsh virsh
