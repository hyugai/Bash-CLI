#!/bin/bash
PYRUN_PATH="$HOME/.pyrun"
LIMITED_NUM_PATHS=50

if ! [ -f "$PYRUN_PATH" ]; then
    touch "$PYRUN_PATH"
fi

_log_path() {
    if (($(grep -c "$1" "$PYRUN_PATH") == 0)); then
        echo "$1" >> "$PYRUN_PATH"
    fi

    return
}

#TODO
_log_path_with_name() {
    if (($(grep -c "$1=$2" "$PYRUN_PATH") == 0)); then
        echo "$1" >> "$PYRUN_PATH"
    else
        read -rp "This name's been used, do you want to overwrite it? [y/n]"
        case "$REPLY" in
            y)
                echo "$1=$2" >> "$PYRUN_PATH"
                ;;
            n)
                command ...
                ;;
            *)
                command ...
                ;;
        esac
    fi

    return
}

_truncate_exceeded_paths() {
    num_paths=$(wc -l "$PYRUN_PATH" | grep -oE '[[:digit:]]+')
    if (("$num_paths" > "$1")); then
        exceeded_paths=$(("$num_paths" - "$1"))
        sed -i "1,${exceeded_paths}d" "$PYRUN_PATH"
    fi
    
    return
}

#TODO
_find_path_by_name() {
    return
}

#TODO

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
        last_used_path=$(tail -n 1 "$PYRUN_PATH")
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
    -n|--set-mnemonic-name) 
        validate_python_file "$2"
        ;;
    -l|--set-limit)
        if [ "$2" ]; then
            _truncate_exceeded_path "$2"
        else
            _truncate_exceeded_paths "$LIMITED_NUM_PATHS"
        fi
        ;;
    -h|--help)
        echo "More info about this command!"
        ;;
    *)
        echo "Invalid argument!" >&2
        exit 1
        ;;
esac
