function shrinker(){
    local -a new_path
    cut_len=${1:=1}
    max_len=20
    if [[ ${PWD} =~ ^${HOME} ]]  ; then
        init="~${PWD#${HOME}}"
    else
        init=${PWD}
    fi
    if [ ${#init} -le $max_len ] ; then
        echo $init
    else
        idx=0
        # Force field splitting at /
        split=(${(@s:/:)init})
        first=${split[1]}
        len=${#split[*]}
        for item in ${split[@]} ; do
            (( idx+=1 ))
            if [ ${item} = "~" ] ; then
                continue
            fi
            if [ ${idx} -eq ${len} ] ; then
                continue
            fi
            new_path+=(${item[1,${cut_len}]})
        done
        combo=${(j:/:)new_path}
        if [ ${first} = "~" ] ; then
            combo="~/${combo}"
        else
            combo="/${combo}"
        fi
        echo "${combo}/$(basename ${init})"
    fi
}
