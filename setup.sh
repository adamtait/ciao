#!/usr/bin/env bash

source "_shared.sh"

if [[ ! -d $D ]]; then
    echo "--- creating ${D}"
    mkdir $D
fi

if [[ ! -f $F ]]; then
    echo "--- creating ${F}"
    touch $F
fi

if [[ ! -h $D/_shared.sh ]]; then
    echo "--- linking _shared.sh to ${D}/_shared.sh"
    ln -s _shared.sh $D/_shared.sh
fi

if [[ ! -h $D/trigger.sh ]]; then
    echo "--- linking trigger.sh to ${D}/trigger.sh"
    ln -s trigger.sh $D/trigger.sh
fi



if [[ $(command -v watchman) ]]; then
    echo "--- setup watchman on ${F}"
    watchman watch-project $D
    watchman -- trigger $D update_etc_hosts -- $D/trigger.sh
else
    echo "--- watchman not installed. please see https://facebook.github.io/watchman for help."
fi



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


