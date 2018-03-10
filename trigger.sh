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

    
SRC_PATH=$D/etc_hosts~orig
TMP_PATH=/tmp/etc_hosts
DEST_PATH=/etc/hosts
    
if [[ ! -f $SRC_PATH ]]; then
    echo -e "--- creating ${SRC_PATH}"
    cp $DEST_PATH $SRC_PATH
fi

# create new /etc/hosts
cp $SRC_PATH $TMP_PATH
awk '{site = $1} {printf "127.0.0.1\t%s\n", site}' $F >> $TMP_PATH

# move new to /etc/hosts
sudo mv $TMP_PATH $DEST_PATH

# flush DNS cache
sudo dscacheutil -flushcache
