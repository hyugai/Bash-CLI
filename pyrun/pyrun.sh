#!/bin/bash
export pyrun_path=

validate_python_file() {
	if [ -e "$1" ] && [ -f "$1" ]; then
		if [[ "$1" =~ ^.+py$ ]]; then
            true
		else
            echo "Not a Python file!" >&2
            exit 1
		fi
	else
        echo "Invalid path! (path: $1)" >&2
        exit 1
	fi

    return
}

case "$1" in
    # validate the $default_path if there's no specified argument
    "")
        if validate_python_file "$pyrun_path"; then
            echo "python $pyrun_path"
        fi
        ;;
    -p|--path)
        if ! [ "$2" ]; then
            echo "No specified path!" >&2
            exit 1
        elif validate_python_file "$2"; then
            echo OK
        fi
        ;;
esac
