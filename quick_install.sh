#!/usr/bin/env bash

SCRIPT_DIR="$( cd -P "$( dirname "$0" )" && pwd )"


# add to .bash_profile
echo "source ${SCRIPT_DIR}/cmd.sh" >> ~/.bash_profile

# run setup
./setup.sh
