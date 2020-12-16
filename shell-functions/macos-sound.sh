#!/bin/bash

function sound {
    usage() {
        echo "usage: ${FUNCNAME[1]} [-h | t(oggle) | off | on | LEVEL ]"
        echo ""
        echo "  LEVEL   numeric value (0-100)"
    }

    local MAX=100
    local MIN=0
    local STEP=10

    if [[ $# -eq 0 ]]; then
        local cur=$(osascript -e 'output volume of (get volume settings)')
        echo "Volume: $cur"
        return
    fi
    while [[ "${1}" ]]; do
        case "${1}" in
            -h|--help)
                usage
                return
                ;;
            level)
                local cur=$(osascript -e 'output volume of (get volume settings)')
                echo "Volume: $cur"
                return
                ;;
            off|mute)
                osascript -e "set volume output muted true"
                return
                ;;
            on)
                osascript -e "set volume output muted false"
                return
                ;;
            -t|toggle)
                local cur=$(osascript -e 'output muted of (get volume settings)')
                if [[ $cur == 'true' ]]; then
                    local new=false
                else
                    local new=true
                fi
                osascript -e "set volume output muted $new"
                return
                ;;
            check|test)
                afplay /System/Library/Sounds/Submarine.aiff
                return
                ;;
            down)
                local cur=$(osascript -e 'output volume of (get volume settings)')
                local new=$(($cur - $STEP < $MIN ? $MIN : $cur - $STEP))
                osascript -e "set volume output volume $new"
                return
                ;;
            up)
                local cur=$(osascript -e 'output volume of (get volume settings)')
                local new=$(($cur + $STEP > $MAX ? $MAX : $cur + $STEP))
                osascript -e "set volume output volume $new"
                return
                ;;
            *)
                if [[ $1 -ge 0 && $1 -le 100 ]]; then
                    # example: sound 30
                    local vol=$(($1 > $MAX ? MAX : $1))
                    osascript -e "set volume output volume $vol"
                else
                    usage
                fi
                return
                ;;
        esac
    done
}
