#!/bin/bash
# Script to let you edit files directly in s3

. "${BASH_SOURCE%/*}/foovi.sh"

FILE="$1"

if [[ -z $FILE ]]; then
    echo "Usage: $0 FILE"
    echo
    echo "Edit files in S3"
    echo
    echo "FILE -- an s3 URI pointing to the file to edit"
    exit 1
fi

get() {
    aws s3 cp "$FILE" "$1"
}

post() {
    aws s3 cp "$1" "$FILE"
}

foovi
