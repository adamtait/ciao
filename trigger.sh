#!/usr/bin/env bash

source "_shared.sh"

    
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

# copy new to /etc/hosts
sudo cp $TMP_PATH $DEST_PATH
rm -rf $TMP_PATH

# flush DNS cache
sudo dscacheutil -flushcache
