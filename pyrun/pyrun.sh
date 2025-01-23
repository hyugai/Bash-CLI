#!/bin/bash

# constant
PYRUN_FILE="${HOME}/.pyrun"

# supporting functions
get_names_associated_with_path() {
    return
}

# command
case "$1" in
    "")
        read -ra line <<< "$(sort -k 2,3 "$PYRUN_FILE" | tail -n 1)"
        if [ -f "${line[0]}" ]; then
            echo "python ${line[0]}"
        else
            echo "error: Invalid path(${line[0]})!"
            read -rp  "Do you want to delete it? [Y/n]: "
            case "${REPLY,,}" in
                y)
                    sed -i "/^${line[0]//\//\\\/}/d" "$PYRUN_FILE"
                    ;;
                n)
                    exit 0
                    ;;
                *)
                    echo "error: Invalid option!" >&2
                    exit 1
                    ;;
            esac
        fi
        ;;

    *.py)
        abs_path=$(readlink -f "$1")
        if [ -f "$abs_path" ]; then
            # replace '/' with '\/' to distiguish the '/' of '/pattern/action' and '/' of the absolute path
            # use '\/' -> '\', '\\\/' -> '\/' for string expension
            # '\\' as a literal escape sequence
            sed -i "/^${abs_path//\//\\\/}/d" "$PYRUN_FILE"
            echo "$abs_path $(date +'%Y/%m/%d %H:%M:%S')" >> "$PYRUN_FILE"
            echo "python $abs_path"
        else
            echo "error: Invalid path!" >&2
            exit 1
        fi
        ;;

    -n|--name)
        ;;

    *)
        echo "error: Invalid argument!" >&2
        exit 1
        ;;
esac
