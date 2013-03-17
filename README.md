enver
=====

Execute a command with environmet variables loaded form `.env` file


Usage
-----

    ./envify.sh <command>

Example: loading `.env` from the current directory

    echo "FOO=BAR" > .env
    ./envify.sh printenv | grep FOO
    # FOO=BAR
    rm .env

Example: loading `.env` from the directory of `<command>`
or from any of it's parent directories

    mkdir -p /tmp/one/two/three
    echo '#!/usr/bin/env bash' > /tmp/one/two/three/magic.sh
    echo 'printenv' >> /tmp/one/two/three/magic.sh
    chmod +x /tmp/one/two/three/magic.sh

    echo 'FOO=THREE' > /tmp/one/two/three/.env
    echo 'FOO=TWO' > /tmp/one/two/.env
    echo 'FOO=ONE' > /tmp/one/.env

    ./envify.sh /tmp/one/two/three/magic.sh | grep FOO
    # FOO=THREE

    rm /tmp/one/two/three/.env
    ./envify.sh /tmp/one/two/three/magic.sh | grep FOO
    # FOO=TWO

    rm /tmp/one/two/.env
    ./envify.sh /tmp/one/two/three/magic.sh | grep FOO
    # FOO=ONE

    rm /tmp/one/.env
    ./envify.sh /tmp/one/two/three/magic.sh | grep FOO
    # Error: couldn't find .env
