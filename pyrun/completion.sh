#!/bin/bash

# constant
PYRUN_FILE="${HOME}/.pyrun"

# supporting functions
retrieve_names_associated_with_paths() {
    declare -a associated_paths

    while read -r path _ _ name; do
        if [ "$name" ]; then
            associated_paths+=("${name}:${path}")
        fi
    done < "$PYRUN_FILE"

    echo "${associated_paths[@]}"
    return
}

# completion
_pyrun_completion() {
    mapfile -t COMPREPLY < <(compgen -W "$(retrieve_names_associated_with_paths)" -- "${COMP_WORDS[1]}")
}

complete -F _pyrun_completion pyrun
