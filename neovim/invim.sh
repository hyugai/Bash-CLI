#!/bin/bash

# check python virtual env if it's eligible for running the python script
validate_python_env () {
    if _=$(python --version); then
        num_matches=$(pip list | grep -cE 'bs4|lxml|requests')
        case "$num_matches" in
            3)
                true
                ;;
            [0-2])
                echo Python env does not meet requirements! >&2
                exit 1
                ;;
        esac
    else
        echo Python env not found! >&2
        exit 1
    fi

    return
}

# use curl to fetch release page and store it in an shell variable
get_latest_ver () {
    if validate_python_env; then
        ver=$(python ./neovim/check_latest_nvim.py)
        echo ${ver/Nvim}
    else
        exit 1
    fi

    return 
}

get_current_ver () {
    # inform
    ver=$(nvim --version | grep -oE v[\.[:digit:]]+)
    if [ $ver ]; then
        echo ${ver/v}
    else
        exit 1 
    fi

    return
}

install_nvim () {
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux64.tar.gz

    patt='export PATH="$PATH:/opt/nvim-linux64/bin"'
    patt_count=$(grep -c "$patt" ~/.bashrc)

    if (( patt_count == 0 )); then
        echo "$patt" >> ~/.bashrc
    fi

    return
}

# drop-down menu
echo -ne "Options:
\t0) Quit
\t1) Install NeoVim
"

# user's input stored in REPLY
read -p "Select -> "

case "$REPLY" in 
    0)  
        exit 0
        ;;
    1)
        # current version
        if current=$(get_current_ver); then
            true
        fi
        # latest version
        if latest=$(get_latest_ver); then
            true
        else
            exit 1
        fi

        # checking and installing
        if [ "$current" != "$latest" ]; then
            echo "Installing NeoVim..."
            install_nvim
            echo "Done! You've installed NeoVim version of $(get_current_ver)"
        elif [ "$current" == "$latest" ]; then
            echo "You're up to date"
        else
            exit 1
        fi
        ;;
    *)  
        echo Invalid entry >&2
        exit 1
        ;;
esac
