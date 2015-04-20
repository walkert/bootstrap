_qemu()
{
    local cur prev configfile
    local -a config

    COMPREPLY=()
    _get_comp_words_by_ref -n : cur prev
    #cur=`_get_cword :`
    #prev=`_get_pword`
    _sub_check && return 0
    case $prev in
        snapshot)
            _snap_q
            return 0
        ;;
    esac
    COMPREPLY=( $(compgen -W "create snapshot" -- ${cur}) )
}

_list_images()
{
    IMAGE_DIR="/apps/images"
    images=$(ls ${IMAGE_DIR}/*.img 2>/dev/null)
    if [ -n "$images" ] ; then
        for image in $images ; do
            COMPREPLY=( ${COMPREPLY[@]} $image )
        done
    fi
    COMPREPLY=($(compgen -W '${COMPREPLY[@]}' -- "$cur" ))
}

_snap_q()
{
    COMPREPLY=( $(compgen -W "-l" -- ${cur}) )
}

_sub_check()
{
    set -- "${COMP_WORDS[@]}"
    if [ $# -eq 5 ] ; then
        return 0
    fi
    if [ $# -eq 4 ] ; then
        if [ "$2" = "snapshot" ] ; then
            if [ "$3" = "-l" ] ; then
                _list_images
                return 0
            fi
        fi
    fi
    return 1
}
complete -F _qemu qemu-img
