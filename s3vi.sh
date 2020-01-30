#!/bin/bash
# Script to let you edit files directly in s3

. "${BASH_SOURCE%/*}/foovi.sh"

ARG="$1"

if [[ -z $ARG ]]; then
    echo "Usage: $0 FILE"
    echo
    echo "Edit files in S3"
    echo
    echo "FILE -- an s3 URI pointing to the file to edit"
    exit 1
fi

get() {
    aws s3 cp "$ARG" "$1"
}

post() {
    aws s3 cp "$1" "$ARG"
}

foovi
