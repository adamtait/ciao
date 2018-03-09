#!/usr/bin/env bash

source "_shared.sh"

function blocksite () {
    if [[ "${1}" = "add" ]]; then
        echo "${2}" >> $F
    elif [[ "${1}" = "remove" ]]; then
        sed '/${2}/d' $F > $F
    else
        echo "USAGE: blocksite (add|remove) [website address]"
        echo "Example: blocksite add facebook.com"
    fi
}
