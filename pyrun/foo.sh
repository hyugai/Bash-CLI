#!/bin/bash

declare -a associated_paths

while read -r path _ _ name; do
    if [ "$name" ]; then
        associated_paths+=("${name}:${path}")
    fi
done < "${HOME}/.pyrun"

echo "${associated_paths[@]}"
