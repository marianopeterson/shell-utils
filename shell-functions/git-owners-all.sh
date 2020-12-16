#!/bin/bash

function owners {
    usage() {
        echo "usage: ${FUNCNAME[1]} [-v]"
        echo ""
        echo "  Print owners for git repos in current directory tree"
        echo ""
        echo "  -v   Verbose"
    }

    local verbose=false
    if [[ $1 == "-h" || $1 == "--help" ]]; then
        usage
        return
    elif [[ $1 == "-v" ]]; then
        verbose=true
    fi

    local NORMAL=$(tput sgr0)
    local BOLD=$(tput bold)
    local YELLOW=$(tput setaf 11)
    local owners

    find . -type f -name "CODEOWNERS" | sort | while read line; do
        # column -s' ' -t 2 test.out
        dir=${line%%/.github*}
        dir=${dir%/CODEOWNERS}
        dir=${dir#./}
        if [ "$verbose" = false ]; then
            owners=$(grep -Eo "@(\w|/|\-)+" $line | sort -u | xargs | sed -e 's/ /,/g')
            echo "$BOLD$YELLOW${dir}$NORMAL $owners"
        else
            echo "$BOLD$YELLOW${dir}$NORMAL"
            grep -vE "(^[#\s]|^$)" "$line" | sort | while read -r grepline; do
                echo "    ${grepline}"
            done
            echo ""
        fi
    done
}
