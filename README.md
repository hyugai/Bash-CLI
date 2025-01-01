# CLI-SOME NOTES

REDIRECTION
- >[regular file] -> redirect the standard output from a successfully executed command to the [file]
    - [number]>&[number] -> redirect from standard files abbreviated as numbers (0, 1, 2) to one of the standard files
    - &>[regular file] -> redirect from both standard output and error to the [regular file]

SHELL EXPANSION
- Some special shell's variables:
    - $? -> the exit status of the last used command
    - $# -> the number of arguments passed to the command line
    - $* -> expand to the list of positional arguments starting with 1, BUT
        + no double quotes -> apply word-splitting to each argument and break them into smaller arguments if splitted
        + with double quotes -> expand inside the double quotes, NO world-splitting, and finally result in 1 single string
    - $@ -> like *, BUT
        + with double quotes, keep the list of positional parameters stay the same, no concatenate or apply word-splitting

