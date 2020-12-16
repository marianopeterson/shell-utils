#!/bin/bash

function tm {
    usage() {
        echo "Convience wrapper for tmux"
        echo ""
        echo "usage: $FUNCNAME HOST [SESSION]"
        echo "       $FUNCNAME -h|--help"
        echo "       $FUNCNAME HOST -l|--list"
        echo "       $FUNCNAME HOST -k|--kill SESSION"
        echo ""
        echo "  HOST        Connect to a HOST and create a default session if one doesn't exist."
        echo "  SESSION     Connect to a session. Creates the session if it doesn't exist."
        echo "  -l          List existing sessions."
        echo "  -k SESSION  Kill the session."
    }

    local host=""
    local session=""
    local command="connect"

    if [[ $# -eq 0 ]]; then
        usage
        return
    fi
    while [[ "$1" ]]; do
        echo "check args $1"
        case "${1}" in
            -h|--help)
                usage
                return
                ;;
            -l|--list)
                command='list'
                shift
                ;;
            -k|--kill)
                command='kill'
                shift
                ;;
            *)
                if [[ -z $host ]]; then
                    host=$1
                elif [[ -z $session ]]; then
                    session=$1
                fi
                shift
                ;;
        esac
    done
    if [[ $command == 'list' ]]; then
        if [[ -z $host ]]; then
            usage
            return 1
        fi
        ssh $host -t "tmx2 ls" 2>/dev/null
    elif [[ $command == 'kill' ]]; then
        if [[ -z $host || -z $session ]]; then
            usage
            return 1
        fi
        ssh $host -t "tmx2 kill-session -t $session" 2>/dev/null
    else
        if [[ -z $host || -z $session ]]; then
            usage
            return 1
        fi
        ssh $host -t "tmx2 new -As $session" 2>/dev/null
    fi
}
