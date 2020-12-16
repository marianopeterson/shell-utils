#!/bin/bash

function xnotes {
    local JOURNAL_DIR="${HOME}/journal/"
    local entry=$(date -v -Mon "+%Y-%m-%d")
    local heading="# "$(date -v -Mon "+%a %b %d, %Y")
    
    usage() {
        echo "NAME"
        echo "    ${FUNCNAME[1]} -- Open an editor for weekly notes"
        echo ""
        echo "SYNOPSIS"
        echo "    ${FUNCNAME[1]} [-h] [-n] [-p] [-t TOOL]"
        echo ""
        echo "DESCRIPTION"
        echo "    -h|--help     Print usage"
        echo "    -n|--next     Open next week's notes"
        echo "    -p|--prev     Open last week's notes"
        echo "    -t|--tool     Open in code | mate | subl | vim"
       echo ""
    }

    while [[ ${1} ]]; do
        case "$1" in
            -p|--prev)
                local entry=$(date -v -1w -v -Mon "+%Y-%m-%d")
                local heading="# "$(date -v -1w -v -Mon "+%a %b %d, %Y")
                shift
                break
                ;;
            -n|--next)
                local entry=$(date -v +1w -v -Mon "+%Y-%m-%d")
                local heading="# "$(date -v +1w -v -Mon "+%a %b %d, %Y")
                shift
                break
                ;;
            -t|--tool)
                tool="$2"
                shift
                shift
                break
                ;;
            *|-h|--help)
                echo "----------------"
                usage
                return
        esac
    done
    local filename="${JOURNAL_DIR}${entry}.md"
    if [ ! -d "$JOURNAL_DIR" ]; then
        echo "mkdir -p $JOURNAL_DIR"
        mkdir -p "$JOURNAL_DIR"
    fi
    if [ ! -f $filename ]; then
        echo $heading >> $filename
        echo "" >> $filename
        echo "# " >> $filename
    fi
    local line=$(wc -l $filename | awk '{print $1}')
    case "$tool" in
        code|vs|vscode)
            code --goto $filename:$line
            ;;
        mate)
            /usr/local/bin/mate --no-wait --line $line $filename
            ;;
        *|vi|vim)
            # To open vim in insert mode, add +startinsert:
            # vi '+normal GA' +startinsert $filename
            vi '+normal GA' $filename
            ;;
    esac
}
