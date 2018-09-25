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




echo -e "\n########## CIAO Setup: Begin ##########"

if [[ ! -d $D ]]; then
    echo "--- creating ${D}"
    mkdir $D
fi

if [[ ! -f $F ]]; then
    echo "--- creating ${F}"
    touch $F
fi

if [[ ! -f $CONFIG_PATH ]]; then
    echo "--- create default configuration file"
    CONFIG_EXAMPLE_PATH=${SCRIPT_DIR}/config.example
    cp $CONFIG_EXAMPLE_PATH $CONFIG_PATH
fi

if [[ ! -f $SRC_PATH ]]; then
    echo "--- creating ${DEST_PATH} backup at ${SRC_PATH}"
    cp $DEST_PATH $SRC_PATH
fi

if [[ ! -f $STATE ]]; then
    echo "--- set initial ON state"
    touch $STATE
fi

if [[ ! -d $OVERRIDES ]]; then
    echo "--- creating ${OVERRIDES}"
    mkdir $OVERRIDES
fi


for file_path in $(find "${SCRIPT_DIR}/overrides" -type f); do
    file_name=$(basename "$file_path")
    if [[ ! -h ${OVERRIDES}/${file_name} ]]; then
        echo "--- linking global override ${file_name}"
        ln -s ${file_path} ${OVERRIDES}/
    fi
done




echo -e "\n########## CIAO Setup: Fin ##########\n"
