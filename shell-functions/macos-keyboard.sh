#!/bin/bash

function keyboard {
    usage() {
        echo "Toggles keyboard mapping between Mac and Windows keyboards"
        echo ""
        echo "usage: ${FUNCNAME[1]} [-h | mac | win ]"
        echo ""
        echo "  mac     Restores factory settings by removing key overrides"
        echo "  win     Remaps the [⊞ WIN] key to [⌥ Option], and the [Alt] key to [⌘ Command]"
    }

    local OS_KEY="0x7000000E2"
    local LEFT_ALT_KEY="0x7000000E3"
    local SRC='"HIDKeyboardModifierMappingSrc"'
    local DST='"HIDKeyboardModifierMappingDst"'

    if [[ $# -eq 0 ]]; then
        usage
        return
    fi

    case "$1" in
        -h|--help|help)
            usage
            return ;;
        apple|mac|macos|reset)
            # reset them to do their normal thing
            hidutil property --set "{\"UserKeyMapping\":[ {$SRC:$OS_KEY, $DST:$OS_KEY}, {$SRC:$LEFT_ALT_KEY, $DST:$LEFT_ALT_KEY} ]}" 1>/dev/null
            return ;;
        microsoft|ms|pc|win|windows)
            # swap command and alt keys
            hidutil property --set "{\"UserKeyMapping\":[ {$SRC:$OS_KEY, $DST:$LEFT_ALT_KEY}, {$SRC:$LEFT_ALT_KEY, $DST:$OS_KEY} ]}" 1>/dev/null
            return ;;
        *)
            usage
            return ;;
    esac
}
