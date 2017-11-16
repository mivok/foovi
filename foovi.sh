#!/bin/bash
cleanup() {
    # Cleanup on exit
    err=$?
    if [[ $err -eq 130 || $err -eq 143 ]]; then # SIGINT/SIGTERM
        echo "Cleaning up..."
    fi
    trap '' EXIT INT TERM
    # Delete the temporary file
    rm -f "$TEMPFILE"
    exit $err
}

yesno() {
    # Yes/no prompt
    # First argument is the default (y or n), the rest is the prompt
    local DEFAULT
    local PROMPT
    DEFAULT="$1"
    shift
    if [[ $DEFAULT == "y" ]]; then
        PROMPT="(Y/n)"
    else
        PROMPT="(y/N)"
    fi
    REPLY=x
    while [[ ! $REPLY =~ ^[YyNn]?$ ]]; do
        echo -n "$* $PROMPT "
        read -r
    done
    if [[ -z $REPLY ]]; then
        [[ $DEFAULT == "y" ]]
        return # True (0) if the default was y, else false (1)
    fi
    [[ $REPLY =~ ^[Yy]$ ]]
}

modtime() {
    # Get the modification time of the file in seconds since the epoch
    # Use the correct stat command for the platform
    if [[ $(uname) == "Linux" ]]; then
        stat -c "%Y" "$1"
    else
        stat -f "%c" "$1"
    fi
}

edit_loop() {
    # Edit a file and exit if it's unchanged and the user doesn't override
    [[ -z $EDITOR ]] && EDITOR=vi
    local MODTIME
    local COMMAND

    # The function you wish to call as part of the edit loop
    COMMAND="$1"

    while true; do
        MODTIME=$(modtime "$TEMPFILE")
        "$EDITOR" "$TEMPFILE"
        if [[ $(modtime "$TEMPFILE") == "$MODTIME" ]]; then
            yesno n "File wasn't modified. Submit anyway?" || return 1
        fi
        if $COMMAND "$TEMPFILE"; then
            return 0
        else
            yesno y "Error submitting changes, re-edit?" || return 1
        fi
    done
}

foovi() {
    TEMPFILE=$(mktemp)
    trap cleanup EXIT INT TERM
    get "$TEMPFILE"
    edit_loop post
}
