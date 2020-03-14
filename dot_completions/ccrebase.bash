_ccrebase () {

    local cur_word prev_word options start_opts extra

    # COMP_WORDS is an array of words in the current command line.
    # COMP_CWORD is the index of the current word (the one the cursor is
    # in). So COMP_WORDS[COMP_CWORD] is the current word; we also record
    # the previous word here, although this specific script doesn't
    # use it yet.

    cur_word="${COMP_WORDS[COMP_CWORD]}"
    prev_word="${COMP_WORDS[COMP_CWORD-1]}"


    # command options
    options="-baseline -mibs -latest -recommended -complete -resume -cancel -help"
    start_opts="-q -nq -t -all -nomibs -preview"

    # Only perform completion if the current word starts with a dash ('-'),
    # meaning that the user is trying to complete an option.
    if [[ ${cur_word} == -* ]] ; then

        if [[ ${COMP_CWORD} -eq 1 ]]; then
            # Main actions
            COMPREPLY=( $(compgen -W "${options}" -- ${cur_word}) )
            return
        else
            local extra query_ctrl start_ctrl
    
            extra="-g -t -preview"   # valid for all commands
            query_ctrl="-q -nq"      # query or no query
            start_ctrl="-all -nomibs -from " # include mibs or not, choose project

            case ${COMP_WORDS[1]} in
                -b*|-l*|-rec*) 
                    COMPREPLY=( $(compgen -W "${start_ctrl} ${query_ctrl} ${extra} " -- ${cur_word}) )
                    return
                    ;;
                -can*|-comp*|-res*)
                    # canel | complete | resume
                    COMPREPLY=( $(compgen -W "${extra}" -- ${cur_word}) )
                    return
                    ;;
                -help)
                    return ;; 
                -mibs)
                    COMPREPLY=( $(compgen -W "${query_ctrl} ${extra} " -- ${cur_word}) )
                    return
                    ;;
                *)
                    return ;;
            esac
        fi
    fi
}

complete -F _ccrebase ccrebase


