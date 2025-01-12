#!/bin/bash
PYRUN_PATH="$HOME/.pyrun"
LIMITED_NUM_PATHS=50

if ! [ -f "$PYRUN_PATH" ]; then
    touch "$PYRUN_PATH"
fi

# validate the python file
validate_python_file() {
	if [ -f "$1" ]; then
		if [[ "$1" =~ ^.+py$ ]]; then
            true
		else
			echo "Not a file!" >&2
			exit 1
		fi
	else
		echo "error: Invalid path! (path: $1)" >&2
		exit 1
	fi

    return
}

# log path
_log_path() {
    if (($(grep -c "$1" "$PYRUN_PATH") == 0)); then
        echo "$1" >> "$PYRUN_PATH"
    fi

    return
}

#TODO: log the specified path with the mnemonic name
_log_path_with_name() {
    num_existings=$(grep -n "^${1}=${2}$" "$PYRUN_PATH" | wc -w)

    if (("$num_existings" == 0)); then
        echo "${1}=${2}" >> "$PYRUN_PATH"

    else
        read -rp "This name's been used, do you want to overwrite it? [y/n]"
        case "$REPLY" in
            y)
                sed -i "/^${1}/d" "$PYRUN_PATH"
                echo "${1}=${2}" >> "$PYRUN_PATH"
                ;;
            n)
                echo "error: Repeated name!" >&2
                exit 1
                ;;
            *)
                echo "error: Invalid option!" >&2
                exit 1
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

#TODO: find path by name
_find_path_by_name() {
    return
}


# 
case "$1" in
    # run last used path
    "")
        last_used_path=$(tail -n 1 "$PYRUN_PATH")
        if [ "$last_used_path" ] && validate_python_file "$last_used_path"; then
            echo "python $last_used_path"
        else
            echo "error: No path are found or valid!" >&2 
            exit 1
        fi
        ;;

    # only run the specified python file
    *py)
        validate_python_file "$1"
        echo "python $1"
        ;;

    # log the python file's path
    -d|--set-default)
        validate_python_file "$2"
        _log_path "$2"
        ;;

    # use the path assosicated with the already-set name
    # TODO: validate name
    -n|--name) 
        true
        ;;

    -l|--set-limit)
        if [ "$2" ]; then
            _truncate_exceeded_path "$2"
        else
            _truncate_exceeded_paths "$LIMITED_NUM_PATHS"
        fi
        ;;

    -p|--path)
        case "$3" in
            -N|--set-mnemonic-name)
                if validate_python_file "$2" && [ "$4" ]; then
                    _log_path_with_name "$4" "$2"
                else
                    echo "error: Check the path or required path's name is missing!" >&2
                    exit 1
                fi
                ;;
            "")
                if validate_python_file "$2"; then echo "The path is valid!" ;fi
                ;;
            *)
                echo "Invalid option!" >&2 
                exit 1
                ;;
        esac
        ;;

    -h|--help)
        echo "More info about this command!"
        ;;

    *)
        echo "error: Invalid argument!" >&2
        exit 1
        ;;
esac
