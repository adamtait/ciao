#!/usr/bin/env bash

# get_script_dir is defined in setup.sh, which should be source'd in current bash env
SCRIPT_DIR=$(get_script_dir "${BASH_SOURCE[0]}")
source "${SCRIPT_DIR}/_shared.sh"



TMP_PATH=$D/.hosts_file.tmp

add_domains_to_tmp_path ()
{
    declare -a domains=("${!1}")
    for d in "${domains[@]}"
    do
        IPv4_PAIR="${IPv4_DEST}\t\t${d}"
        IPv6_PAIR="${IPv6_DEST}\t\t${d}"
                
        # when config $DEST_DNS_FIRST=true
        if $DEST_DNS_FIRST; then
            IPv4_PAIR="${d}\t\t${IPv4_DEST}"
            IPv6_PAIR="${d}\t\t${IPv6_DEST}"
        fi

        echo -e "${IPv4_PAIR}" >> $TMP_PATH
        echo -e "${IPv6_PAIR}" >> $TMP_PATH
    done
}


# create new hosts file copy
if [[ ! -f $SRC_PATH ]]; then
    touch $SRC_PATH 2>&1 /dev/null
fi

cp $SRC_PATH $TMP_PATH


# when $STATE is ON
if [[ -f $STATE ]]
then
    declare -a domains
    IFS=$'\n' read -d '' -r -a domains < "${F}"

    # check overrides dir for domains
    for f in "${OVERRIDES}"/*; do
        filename=$(basename "${f}")
        if [[ "${domains[@]}" =~ "${filename}" ]]
        then
            IFS=$'\n' read -d '' -r -a ods < "${f}"
            add_domains_to_tmp_path ods[@]
            domains=(${domains[@]/"${filename}"/})
        fi
    done

    # add remaining domains
    add_domains_to_tmp_path domains[@]
fi

echo "--> updating system blocked domains list (${DEST_PATH})"

# move new file to $DEST_PATH (probably /etc/hosts)
if [[ $DEST_PATH == "/etc/hosts" ]]
then
    sudo mv $TMP_PATH $DEST_PATH
    sudo dscacheutil -flushcache   # flush DNS cache
else
    mv $TMP_PATH $DEST_PATH
fi


echo "...fin."
