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
        sed '/${2}/d' $F > $F
    elif [[ "${1}" = "on" ]]; then
        $SCRIPT_DIR/trigger.sh
    elif [[ "${1}" = "off" ]]; then
        cp $SRC_PATH $DEST_PATH
    else
        echo "USAGE: block-domain (add|remove) [website address]"
        echo "Examples:"
        echo "  block-domain add facebook.com"
        echo "  block-domain remove facebook.com"
        echo "  block-domain off"
        echo "  block-domain on"
    fi
}
