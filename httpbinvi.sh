#!/bin/bash
# This is a simple example that will get some data from httpbin.org, let you
# edit it, then post it back to the post endpoint, where it should show in the
# 'json' field.

. "${BASH_SOURCE%/*}/foovi.sh"

ARG="$1"

if [[ -z $ARG ]]; then
    echo "Usage: $0 ARG"
    echo
    echo "Demo foovi script using httpbin"
    echo
    echo "ARG -- an argument to pass to the original get request"
    exit 1
fi

get() {
    curl -s "https://httpbin.org/get?arg=$ARG" > "$1"
}

post() {
    curl -s https://httpbin.org/post -H "Content-Type: application/json" \
        -d "@$1"
}

foovi
