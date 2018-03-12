#!/usr/bin/env bash

get_script_dir () {
    # In case this script is symbolically linked from elsewhere
    # Taken from https://stackoverflow.com/questions/59895/getting-the-source-directory-of-a-bash-script-from-within
    SOURCE=$1
    while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
        DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
        SOURCE="$(readlink "$SOURCE")"
        [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    done
    echo "$( cd -P "$( dirname "$SOURCE" )" && pwd )"
}
export -f get_script_dir


SCRIPT_DIR=$(get_script_dir "${BASH_SOURCE[0]}")
source "${SCRIPT_DIR}/_shared.sh"


ciao () {
    case "$1" in
        list)
            cat $F
            return 0
            ;;
        add)
            echo "${2}" >> $F
            ;;
        remove)
            sed -i '' "/${2/\./\\.}/d" $F
            ;;
        on)
            touch $STATE
            ;;
        off)
            rm -rf $STATE
            ;;
        *)
            echo "$HELP_TEXT"
            return 0
            ;;
    esac

    $SCRIPT_DIR/trigger.sh
}




HELP_TEXT="\
$CMD $VERSION
manage a list of blocked domains. A blocked domain will not recieve
any network requests

Usage: $CMD <command> [<args>]

Available commands are:
          list                  see the list of blocked domains
          add <domain>	        add a new domain (like google.com) to the list of blocked domains
          remove <domain>	remove domain from the list of blocked domains [NOTE: must exactly match previous entries]
          on		        start blocking requests to stored internet domains
          off		        stop blocking requests. Restores /etc/hosts to original state.
                
Examples:
	$CMD add facebook.com
	$CMD remove facebook.com
	$CMD off
	$CMD on

NOTE! requests for added domains will be re-directed to: 
IPv4 127.0.0.1
IPV6 fe80::1%lo0

For full documentation, see: https://github.com/adamtait/$CMD#readme"

