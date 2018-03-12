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

if [[ ! -f $SRC_PATH ]]; then
    echo "--- creating /etc/hosts backup ${SRC_PATH}"
    cp $DEST_PATH $SRC_PATH
fi

if [[ ! -f $STATE ]]; then
    echo "--- set initial ON state"
    touch $STATE
fi

if [[ ! -d $OVERRIDES ]]; then
    echo "--- creating ${OVERRIDES}"
    mkdir $OVERRIDES
    mkdir $OVERRIDES/IPv4
    mkdir $OVERRIDES/IPv6
fi


link_global_overrides () {
    DEST_DIR="${OVERRIDES}/${1}"
    for file_path in $(find "${SCRIPT_DIR}/overrides/${1}" -type f); do
        file_name=$(basename "$file_path")
        if [[ ! -h ${DEST_DIR}/${file_name} ]]; then
            echo "--- linking global override ${file_name}"
            ln -s ${file_path} ${DEST_DIR}
        fi
    done
}

link_global_overrides "IPv4"
link_global_overrides "IPv6"


echo -e "\n########## CIAO Setup: Fin ##########\n"
