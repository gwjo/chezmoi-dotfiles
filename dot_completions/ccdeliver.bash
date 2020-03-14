_ccdeliver () {

    local cur_word prev_word options extra

    # COMP_WORDS is an array of words in the current command line.
    # COMP_CWORD is the index of the current word (the one the cursor is
    # in). So COMP_WORDS[COMP_CWORD] is the current word; we also record
    # the previous word here, although this specific script doesn't
    # use it yet.

    cur_word="${COMP_WORDS[COMP_CWORD]}"
    prev_word="${COMP_WORDS[COMP_CWORD-1]}"


    # command options
    options="-complete -resume -cancel -help"
    extra="-g -n"

    # Only perform completion if the current word starts with a dash ('-'),
    # meaning that the user is trying to complete an option.
    if [[ ${cur_word} == -* ]] ; then

        
        if [[ ${COMP_CWORD} -eq 1 ]]; then
            COMPREPLY=( $(compgen -W "${options}" -- ${cur_word}) )
            return
        else
            COMPREPLY=( $(compgen -W "${extra}" -- ${cur_word}) )
        fi
    else
        COMPREPLY=()
    fi
    return 0
}

complete -F _ccdeliver ccdeliver


