#!/bin/bash

function gpa {
    # gpa is short for "Git Pull All"

    # How to find the escape sequence for a unicode character:
    # printf <paste-unicode-char> | hexdump
    # printf 🚫 | hexdump
    #   000000 f0 9f 9f a5
    #   0000004
    #          ^---------^ <-- prefix each of these with \x
    # Then...
    # echo -e "\xf0\x9f\x9a\xab"
    #
    local GREEN="\033[0;32m"
    local RED="\033[0;31m"
    local RESET_FONT="\033[0m"
    local CHECK="\xE2\x9C\x94"
    local SKULL="\xE2\x98\xA0"
    local NO_ENTRY="\xf0\x9f\x9a\xab"
    local ICON_PASS="${CHECK}"
    local ICON_FAIL="${NO_ENTRY}"
    local CLEAR_LINE="\033[0K"

    local GIT_FORMAT='  %C(yellow)%h %<(12,trunc)%C(white)%an %C(green)%s %C(dim white)(%cr)%C(reset)%C(yellow)%d%Creset'

    local starting_dir="$(pwd)"
    local hashes=''

    function git_is_dirty {
        [[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]] && return 0 || return 1
    }

    function log_skip {
        echo -e "\r${CLEAR_LINE}${RED}${ICON_FAIL} $1${RESET_FONT}"
    }

    function log_success {
        echo -en "\r${CLEAR_LINE}${GREEN}${ICON_PASS}${RESET_FONT} $1"
    }

    # find the ".git" dirs, but exclude the ones that are in hidden/dot dirs
    # because they're likely to be submodules that I don't want to fetch right now.
    find . -type d -name ".git" | sort | grep -vE "/\..+/" | while read d; do
        dir_path=$(dirname "$d")
        dir_path=${dir_path:2} # remove first chars containing "./"
        cd "$dir_path"
        if [ ! -d .git ]; then
            log_skip "Skipped $dir_path because it does not have a .git directory"
        elif git_is_dirty ; then
            log_skip "Skipped $dir_path because it has uncommitted changes"
            git status -s
        else
            echo -n "Updating  $dir_path"
            hashes=$(git pull 2>&1 | grep "^Updating " | cut -d' ' -f2)
            log_success "Updated $dir_path"
            if [ -z "$hashes" ]; then
                echo -e " (no change)"
            else
                echo -e " (${hashes})"
                git --no-pager log --format="${GIT_FORMAT}" ${hashes}
            fi
        fi
        cd "$starting_dir"
    done
}