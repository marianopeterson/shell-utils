#!/bin/bash

function g {
    usage() {
        echo "usage: ${FUNCNAME[1]} SHA [--stat]"
        echo ""
        echo ""
        echo "  SHA    Commit SHA to find in the cwd tree and print":w

    }
    if [[ $# -ne 1 || ${1} == "-h" || ${1} == "--help" ]]; then
        usage
        return
    fi

    local SHA=$1
    local GIT_FORMAT='  %C(yellow)%h %<(12,trunc)%C(white)%an %C(green)%s %C(dim white)(%cr)%C(reset)%C(yellow)%d%Creset    '
    local starting_dir="$(pwd)"

    find . -type d -name ".git" | sort | grep -vE "/\..+/" | while read d; do
        dir_path=$(dirname "$d")
        dir_path=${dir_path:2} # remove first chars containing "./"
        cd "$dir_path"
        if git cat-file -e ${SHA}^{commit} >& /dev/null; then
            git show --first-parent --function-context --patch-with-stat $SHA
            cd "$starting_dir"
            return
        fi
        cd "$starting_dir"
    done
}
