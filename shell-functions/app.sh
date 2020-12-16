#!/bin/bash

# ABOUT
# Creates a MacOS app wrapper for a website. For example, wrap music.google.com
# in a MacOS app so that it gets its own icon in the CMD+TAB bar, separate from
# the browser you use for everything else.

# REFERENCE
# Original script:
#   https://gist.github.com/demonbane/1065791
#
# Apple:
#   Info.plist has a "CFBundleExecutable" property that enables us to
#   specify the shell script that will launch our app via exec.
#   https://developer.apple.com/library/content/documentation/CoreFoundation/Conceptual/CFBundles/BundleTypes/BundleTypes.html#//apple_ref/doc/uid/10000123i-CH101-SW9
#
# Chromium:
#   Command line switches:
#   https://peter.sh/experiments/chromium-command-line-switches

function app() {

    usage() {
        echo "NAME"
        echo "    $FUNCNAME -- Create a Chrome desktop app"
        echo ""
        echo "SYNOPSIS"
        echo "    $FUNCNAME [-h] [-nui]"
        echo ""
        echo "DESCRIPTION"
        echo "    -h|--help     Print usage"
        echo "    -n|--name     What should the MacOS app be named? (no spaces, eg, GCal)"
        echo "    -u|--url      URL of the web site (eg, https://google.com/calendar/render)"
        echo "    -i|--icon     Icon to use for the MacOs app (eg, /Users/you/Desktop/icon.png)"
        echo ""
    }

    while [[ ${1} ]]; do
        case "${1}" in
            -n|--name)
                local name=${2}
                shift;shift;;
            -u|--url)
                local url=${2}
                shift;shift;;
            -i|--icon)
                local icon=${2}
                shift;shift;;
            *|-h|--help)
                echo ${1}
                usage
                return
        esac
    done

    if [[ -z $name || -z $url || -z $icon ]]; then
        echo "ERROR: Missing required arguments"
        echo ""
        usage
        return
    fi

    local chromePath="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
    local appRoot="/Applications"
    local resourcePath="$appRoot/$name.app/Contents/Resources"
    local execPath="$appRoot/$name.app/Contents/MacOS"
    local profilePath="$appRoot/$name.app/Contents/Profile"
    local plistPath="$appRoot/$name.app/Contents/Info.plist"

    mkdir -p "$resourcePath" "$execPath" "$profilePath"
    if [ -f "$icon" ]; then
        sips -s format tiff "$icon" --out "$resourcePath/icon.tiff" --resampleHeightWidth 128 128 >& /dev/null
        tiff2icns -noLarge "$resourcePath/icon.tiff" >& /dev/null
    fi

    # create the executable
    cat > "$execPath/$name" <<EOF
#!/bin/sh
exec "$chromePath" --app="$url" --user-data-dir="$profilePath" "\$@"
EOF
    chmod +x "$execPath/$name"

    # create the Info.plist
    cat > "$plistPath" <<EOT
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" “http://www.apple.com/DTDs/PropertyList-1.0.dtd”>
<plist version=”1.0″>
<dict>
<key>CFBundleExecutable</key>
<string>$name</string>
<key>CFBundleIconFile</key>
<string>icon</string>
</dict>
</plist>
EOT

    echo "App installed at ${appRoot}/${name}.app"
    open "${appRoot}/${name}.app"

}

