#!/usr/bin/env bash



# get_script_dir is in setup.sh, which should be source'd in current bash env
SCRIPT_DIR=$(get_script_dir "${BASH_SOURCE[0]}")
source "${SCRIPT_DIR}/_shared.sh"


TMP_PATH=$D/etc_hosts.tmp

# create new /etc/hosts copy
cp $SRC_PATH $TMP_PATH

if [[ -f $STATE ]]; then

    IFS=$'\n' read -d '' -r -a domains < "${F}"
    overridden=();
    
    for f in "${OVERRIDES}"/IPv4/*; do
        filename=$(basename "${f}")
        for d in "${domains[@]}"; do
            if [[ "${filename}" = "${d}" ]]; then
                awk '{site = $1} {printf "127.0.0.1\t%s\n", site}' $f >> $TMP_PATH
                overridden=(${overridden[@]} "${d}")
            fi
        done
    done

    for f in "${OVERRIDES}"/IPv6/*; do
        filename=$(basename "${f}")
        for d in "${domains[@]}"; do
            if [[ "${filename}" = "${d}" ]]; then
                IFS=$'\n' read -d '' -r -a ods < "${f}"
                for od in "${ods[@]}"; do
                    echo -e "fe80::1%lo0\t${od}" >> $TMP_PATH
                done
                overridden=(${overridden[@]} "${d}")
            fi
        done
    done

    # remove overridden from domains[@]
    for d in "${overridden[@]}"; do
        domains=(${domains[@]/"${d}"/})
    done

    # add remaining domains as IPv4
    for d in "${domains[@]}"; do
        echo -e "127.0.0.1\t${d}" >> $TMP_PATH
    done
    
fi

echo "--- updating system blocked domains list (/etc/hosts)"

# move new file to /etc/hosts
sudo mv $TMP_PATH $DEST_PATH

# flush DNS cache
sudo dscacheutil -flushcache


echo "...fin."
