#!/usr/bin/env bash

# In case this script is symbolically linked from elsewhere
# Taken from https://stackoverflow.com/questions/59895/getting-the-source-directory-of-a-bash-script-from-within
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
source "${SCRIPT_DIR}/_shared.sh"


function block-domain () {
    if [[ "${1}" = "add" ]]; then
        echo "${2}" >> $F
    elif [[ "${1}" = "remove" ]]; then
        sed -i '' '/${2}/d' $F
    elif [[ "${1}" = "on" ]]; then
        touch $STATE
        $SCRIPT_DIR/trigger.sh
    elif [[ "${1}" = "off" ]]; then
        rm -rf $STATE
        $SCRIPT_DIR/trigger.sh
    elif [[ "${1}" = "list" ]]; then
        cat $F
    else
        echo "block-domain 1.0.1"
        echo "manage a list of blocked domains. A blocked domain will not recieve any network requests (requests will be re-directed to 127.0.0.1)"
        echo "Usage: block-domain <command> [<args>]"

        echo -e "\nAvailable commands are:"
        echo -e "\tlist\t\tsee the list of blocked domains"
        echo -e "\tadd <domain>\tadd a new domain (like google.com) to the list of blocked domains"
        echo -e "\tremove <domain>\tremove domain from the list of blocked domains [NOTE: must exactly match previous entries]"
        echo -e "\ton\t\tstart blocking requests to stored internet domains"
        echo -e "\toff\t\tstop blocking requests. Restores /etc/hosts to original state."
                
        echo -e "\nExamples:"
        echo -e "\tblock-domain add facebook.com"
        echo -e "\tblock-domain remove facebook.com"
        echo -e "\tblock-domain off"
        echo -e "\tblock-domain on"
        echo -e "\nFor full documentation, see: https://github.com/adamtait/DNS_blocker#readme"
    fi
}
