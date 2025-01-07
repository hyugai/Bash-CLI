#!/bin/bash
pyrun_path="$HOME/.pyrun"

if ! [ -f "$pyrun_path" ]; then
    touch "$pyrun_path"
fi

_log_path() {
    if (($(grep -c "$1" "$pyrun_path") == 0)); then
        echo "$1" >> "$pyrun_path"
    fi

    return
}

validate_python_file() {
	if [ -f "$1" ]; then
		if [[ "$1" =~ ^.+py$ ]]; then
            true
		else
			echo "Not a file!" >&2
			exit 1
		fi
	else
		echo "Invalid path! (path: $1)" >&2
		exit 1
	fi

    return
}

case "$1" in
    "")
        last_used_path=$(tail -n 1 "$pyrun_path")
        if [ "$last_used_path" ] && validate_python_file "$last_used_path"; then
            echo "python $last_used_path"
        else
            echo "No path are found or valid!" >&2 
            exit 1
        fi
        ;;
    *py)
        validate_python_file "$1"
        echo "python $1"
        ;;
    -d|--set-default)
        validate_python_file "$2"
        _log_path "$2"
        ;;
    -u|--unset-default)
        true
        ;;
    *)
        echo "Invalid argument!" >&2
        exit 1
        ;;
esac
