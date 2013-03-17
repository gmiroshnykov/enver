#!/usr/bin/env bash

SELF=$0
COMMAND=$1

usage() {
    echo "Usage: $SELF <command>" 1>&2
}

realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

findDotEnv() {
    FULLPATH=`realpath $1`
    if [ -f "$FULLPATH" ]; then
        PARENTPATH=`dirname $FULLPATH`
    else
        PARENTPATH=$PWD
    fi

    while [ "$PARENTPATH" != "/" ]; do
        CANDIDATE="${PARENTPATH}/.env"
        if [ -f "$CANDIDATE" ]; then
            echo "$CANDIDATE"
            return 0
        fi
        PARENTPATH=`dirname $PARENTPATH`
    done

    # fallback
    echo '.env'
}

splitPathIntoParts() {
    saveIFS=$IFS
    IFS='/'
    PATHPARTS=($1)
    IFS=$saveIFS
}

if [ "$COMMAND" == "" ] || [ "$COMMAND" == "-h" ]; then
    usage
    exit 1
fi

DOTENV=`findDotEnv "$COMMAND"`
if [ ! -f "$DOTENV" ]; then
    echo "Error: couldn't find .env" 1>&2
    exit 1
fi

TMPENV=`mktemp /tmp/dotenv.XXXX`

touch $TMPENV
chmod 600 $TMPENV

while read line; do
    echo export $line
done < $DOTENV > $TMPENV

source $TMPENV
rm -f $TMPENV

"${@:1}"
