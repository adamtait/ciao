#!/usr/bin/env bash

# get_script_dir is defined in setup.sh, which should be source'd in current bash env
SCRIPT_DIR=$(get_script_dir "${BASH_SOURCE[0]}")
source "${SCRIPT_DIR}/_shared.sh"



TMP_PATH=$D/.etc_hosts.tmp

# create new /etc/hosts copy
cp $SRC_PATH $TMP_PATH

if [[ -f $STATE ]]; then

    IFS=$'\n' read -d '' -r -a domains < "${F}"

    # check overrides dir for domains
    for f in "${OVERRIDES}"/*; do
        filename=$(basename "${f}")
        if [[ "${domains[@]}" =~ "${filename}" ]]; then
            IFS=$'\n' read -d '' -r -a ods < "${f}"
            for od in "${ods[@]}"; do
                echo -e "${IPv4_DEST}\t${od}" >> $TMP_PATH
                echo -e "${IPv6_DEST}\t${od}" >> $TMP_PATH
            done
            domains=(${domains[@]/"${filename}"/})
        fi
    done

    # add remaining domains
    for d in "${domains[@]}"; do
        echo -e "${IPv4_DEST}\t${d}" >> $TMP_PATH
        echo -e "${IPv6_DEST}\t${d}" >> $TMP_PATH
    done
    
fi

echo "--- updating system blocked domains list (/etc/hosts)"

# move new file to /etc/hosts
sudo mv $TMP_PATH $DEST_PATH

# flush DNS cache
sudo dscacheutil -flushcache


echo "...fin."
