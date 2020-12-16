#!/bin/bash

function gla {
    local GIT_FORMAT='  %C(yellow)%h %<(12,trunc)%C(white)%an %C(green)%s %C(dim white)(%cr)%C(reset)%C(yellow)%d%Creset'
    local starting_dir="$(pwd)"
    local since='';

    usage() {
        echo "usage: ${FUNCNAME[1]} --since '2 days ago'"
        echo ""
        echo "  Print the git log for all repos in the current directory tree"
    }
    case "${1}" in
        -s|--since)
            since=${2}
            ;;
        *)
            usage
            ;;
    esac

    find . -type d -name ".git" | sort | grep -vE "/\..+/" | while read d; do
        dir_path=$(dirname "$d")
        dir_path=${dir_path:2} # strip first two chars ("./")
        cd "$dir_path"
        git --no-pager log --format="$GIT_FORMAT" --since="$since"
        cd "$starting_dir"
    done
}