#!/usr/bin/env bash

# get_script_dir is in setup.sh, which should be source'd in current bash env
SCRIPT_DIR=$(get_script_dir)
source "${SCRIPT_DIR}/_shared.sh"

    
TMP_PATH=$D/etc_hosts.tmp

# create new /etc/hosts copy
cp $SRC_PATH $TMP_PATH

if [[ -f $STATE ]]; then    
    # add root domains
    awk '{site = $1} {printf "127.0.0.1\t%s\n", site}' $F >> $TMP_PATH

    # add all subdomains
    awk '{site = $1} {printf "127.0.0.1\t*.%s\n", site}' $F >> $TMP_PATH
fi

echo -e "\n--- updating system blocked domains list (/etc/hosts)"

# move new file to /etc/hosts
sudo mv $TMP_PATH $DEST_PATH

# flush DNS cache
sudo dscacheutil -flushcache


echo -e "...fin."
