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




if [[ ! -d $D ]]; then
    echo "--- creating ${D}"
    mkdir $D
fi

if [[ ! -f $F ]]; then
    echo "--- creating ${F}"
    touch $F
fi

DEST_FILE=/etc/hosts
if [[ ! -r $DEST_FILE || ! -w $DEST_FILE ]]; then
    echo "--- requesting access to ${DEST_FILE} (sudo chmod 666 ${DEST_FILE})"
    sudo chmod 666 $DEST_FILE
fi


if [[ $(command -v watchman) ]]; then
    echo "--- setup watchman on ${F}"
    watchman watch-project $D
    watchman -- trigger $D update_etc_hosts -- $SCRIPT_DIR/trigger.sh
else
    echo "--- watchman not installed. please see https://facebook.github.io/watchman for help."
fi

