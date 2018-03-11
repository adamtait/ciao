#!/usr/bin/env bash

get_script_dir () {
    # In case this script is symbolically linked from elsewhere
    # Taken from https://stackoverflow.com/questions/59895/getting-the-source-directory-of-a-bash-script-from-within
    SOURCE="${BASH_SOURCE[0]}"
    while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
        DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
        SOURCE="$(readlink "$SOURCE")"
        [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    done
    echo "$( cd -P "$( dirname "$SOURCE" )" && pwd )"
}


SCRIPT_DIR=$(get_script_dir)
source "${SCRIPT_DIR}/_shared.sh"

HELP_TEXT="\
$CMD $VERSION
manage a list of blocked domains. A blocked domain will not recieve any network requests (requests will be re-directed to 127.0.0.1)
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

For full documentation, see: https://github.com/adamtait/$CMD#readme"




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
