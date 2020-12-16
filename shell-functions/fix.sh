#!/bin/bash

function fix() {
    # Also see CDPATH, which provides similar functionality.
    local search_path="${FIX_ROOT:-${HOME}/code}"
    usage() {
        echo "usage: ${FUNCNAME[1]} [REPO]"
        echo ""
        echo "  REPO      Fragment of the repo name to cd into"
        echo ""
        echo "ENVIRONMENT"
        echo "The following environment variables affect the execution of ${FUNCNAME[1]}:"
        echo ""
        echo "  FIX_ROOT  Set the directory in which to search for repos. Default: ${HOME}/code"
    }

    if [[ $1 == "-h" || $1 == "--help" ]]; then
        usage
        return
    elif [[ $# -eq 0 && -d "$search_path" ]]; then
        cd "$search_path"
        return
    fi
    local needle=$1
    # local match=$(find "$search_path" -maxdepth 5 -type d -name ".git" -ipath "*$needle*" | head -n 1)
    # echo "needle: $needle"
    local matches=$(find "$search_path" -maxdepth 5 -type d -name ".git" -ipath "*$needle*")
    local suggeestion
    if [[ $matches == *$'\n'* ]]; then
        suggestion="${matches//\/.git/}"
        suggestion="${suggestion//$search_path\//}"
        echo "$suggestion"
        return 0
    fi
    cd $(dirname ${matches[0]})
}

function _fix_completions() {
    local search_path="${FIX_ROOT:-${HOME}/code}"

    # TODO: improve search to only scan repo names, and ignore matches in the name of the search root
    #       (if I search for a repo with my name in it, every repo will match
    #       because my name is part of my $HOME which is in the search root)
    #       basically using find's -ipath flag creates the problem.
    #
    # Reference: https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial
    # Reference: https://www.thegeekstuff.com/2010/07/bash-string-manipulation/
    #
    if [ "${#COMP_WORDS[@]}" != "2" ]; then
        return
    fi
    
    # We want to execute `find` and store the results as an array. The simple
    # approach of $foo=$(find . -name bar) doesn't work because
    # (a) results are stored as a string making it hard to count results,
    # (b) results are space delimited which breaks when there are spaces in the results,
    # (c) results cannot be easily be passed in to COMPREPLY
    # Therefore we init an array and then read the find results into it.
    # More info: https://stackoverflow.com/questions/8213328/store-the-output-of-find-command-in-an-array#8213509
    local matches=()
    while IFS= read -r -d $'\0'; do
        matches+=("${REPLY%/*}") # delete shortest match of "/*" from back of $REPLY
    done < <(find "$search_path" -maxdepth 5 -type d -name .git -ipath "*${COMP_WORDS[1]}*" -print0)

    if [ "${#matches[@]}" == "1" ]; then
        # There's only one match
        local suggestion="${matches%/.git}" # delete trailing "/.git"
        suggestion="${suggestion##*/}"
        COMPREPLY=("$suggestion")
    else
        # There's more than one match
        # https://stackoverflow.com/questions/10652492/bash-autocompletion-how-to-pass-this-array-to-compgen#11482571
        COMPREPLY=( "${matches[@]##*/}" )  # delete longest match of "*/" from matches[@]
                                           # (leave only the trailing filename)
    fi
}

complete -F _fix_completions fix
