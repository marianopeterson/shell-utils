# Set your computer_name:
read -p "What hostname do you want to give this computer? (default: `hostname`): " hostname
hostname=${hostname:-`hostname`}
 
echo "Set computer name to ${hostname}"
scutil --set ComputerName ${hostname}   # Visible under the Sharing preference
scutil --set HostName ${hostname}       # Command line, ssh, remote login
scutil --set LocalHostName ${hostname}  # Bonjour, Airdrop
#diskutil rename / ${hostname}
defaults write com.apple.smb.server NetBIOSName -string "${hostname}"


###############################################################################
# SHELL & TERMINAL                                                            #
###############################################################################
# https://www.ukuug.org/events/linux2003/papers/bash_tips/

# File: sprout-osx-settings/templates/default/inputrc.erb
#
# "\e[A": history-search-backward
# "\e[B": history-search-forward
# $if Bash
#   Space: magic-space
# $endif
# "\M-o": "\C-p\C-a\M-f "
# set completion-ignore-case on
# set visible-stats on
# set show-all-if-ambiguous on
# "\M-s": menu-complete
#
# echo set completion-ignore-case on | sudo tee -a /etc/inputrc

#echo "allow a user to choose a language input method from a pop-up menu in the login window"
#sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -boolean true

echo "Remove the 'Last login' message from the Terminal"
touch ${HOME}/.hushlogin

echo "Disable AutoMarkPromptLines (the [ before each prompt)"
defaults write com.apple.Terminal AutoMarkPromptLines -int 0

#echo "Disable auto-correct"
#defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -boolean false

# Make bash append rather than overwrite the history on disk
shopt -s histappend
PROMPT_COMMAND='history -a'


###############################################################################
# Finder                                                                      #
###############################################################################

echo "Format date in menu bar"
defaults write com.apple.menuextra.clock IsAnalog -bool false
defaults write com.apple.menuextra.clock DateFormat -string "EEE MMM d h:mm a"
killall SystemUIServer

echo "Autohide the dock"
defaults write com.apple.dock autohide -bool true && killall Dock

# echo "Remove the delay for showing and hiding the dock"
# defaults write com.apple.dock autohide-delay -float 0
# defaults write com.apple.dock autohide-time-modifier -float 0

echo "Do not show Dashboard as a Space"
defaults write com.apple.dock dashboard-in-overlay -boolean true

echo "Expand save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -boolean true

echo "Disable the warning before emptying the Trash"
defaults write com.apple.finder WarnOnEmptyTrash -boolean false

echo "Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -boolean false

echo "Disable disk image verification"
# defaults write com.apple.frameworks.diskimages skip-verify -bool true
# defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
# defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

echo "Automatically open a new Finder window when a volume is mounted"
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true

echo "Finder windows open in home folder"
defaults write com.apple.finder NewWindowTarget -string PfHm
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"

echo "Finder searches the current folder by default"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Update Finder windows to use by default
# Options:
#   Nlsv – List View
#   icnv – Icon View
#   clmv – Column View
#   Flwv – Cover Flow View
echo "Finder windows use List view."
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

echo "Show file extensions in Finder"
defaults write com.apple.finder AppleShowAllExtensions -boolean true

echo "Sidebar icon size Small"
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1

echo "Ask for password when screen is locked"
#defaults write com.apple.screensaver askForPassword -int 1
#defaults write com.apple.screensaver askForPasswordDelay -int 60
# displaysleep: display sleep timer (value in minutes, or 0 to disable)
# disksleep:    disk spindown timer (value in minutes, or 0 to disable)
# sleep:        system sleep timer  (value in minutes, or 0 to disable)
#
# pmset -a displaysleep 20 disksleep 15 sleep 0
#pmset -a displaysleep 20 disksleep 15


echo "Disable smart quotes and dashes as they’re annoying when typing code"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Trackpad: map bottom right corner to right-click
# 
# (I might want to turn this on later if the trackpad proves too sensitive)
#
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
# defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
# defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

echo "Disable natural (iOS style) scrolling"
#defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Increase sound quality for Bluetooth headphones/headsets
#defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40


echo "Enable full keyboard access for all controls"
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 12

# Use scroll gesture with the Ctrl (^) modifier key to zoom
# defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
# defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
# # Follow the keyboard focus while zoomed in
# defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true


# Do I also need...
echo "Show desktop icons as a list sorted by modification time."
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy dateModified" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy dateModified" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy dateModified" ~/Library/Preferences/com.apple.finder.plist

#echo "Increase grid spacing for icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridOffsetX 0.0" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridOffsetY 0.0" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist

echo "Set the size of icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 16" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 16" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 16" ~/Library/Preferences/com.apple.finder.plist

echo "Show item info to the right of the icons on the desktop."
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist


echo "Show icon previews on desktop."
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showIconPreview true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo false" ~/Library/Preferences/com.apple.finder.plist


echo "Resize desktop labels."
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:textSize 12" ~/Library/Preferences/com.apple.finder.plist
# Required for OSX Mavericks: update the cfprefs cache from disk.
killall -u `whoami` cfprefsd
killall Finder


# Disable Dashboard
# defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t show Dashboard as a Space
# defaults write com.apple.dock dashboard-in-overlay -bool true



echo "Add iOS Simulator to Launchpad and Applications folder."
sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone Simulator.app" "/Applications/iOS Simulator.app"


# Hot corners
#
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# Top left screen corner → Mission Control
defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tl-modifier -int 0
# Top right screen corner → Desktop
defaults write com.apple.dock wvous-tr-corner -int 0
defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom left screen corner → Start screen saver
defaults write com.apple.dock wvous-bl-corner -int 0
defaults write com.apple.dock wvous-bl-modifier -int 0

echo "Save screenshots to the Downloads folder"
defaults write com.apple.screencapture location ${HOME}/Downloads


###############################################################################
# Safari & WebKit                                                             #
###############################################################################
# Set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"

# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Allow hitting the Backspace key to go to the previous page in history
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true

# Hide Safari’s bookmarks bar by default
defaults write com.apple.Safari ShowFavoritesBar -bool false

# Hide Safari’s sidebar in Top Sites
defaults write com.apple.Safari ShowSidebarInTopSites -bool false

# Disable Safari’s thumbnail cache for History and Top Sites
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

# Enable Safari's debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -boolean true

# Make Safari’s search banners default to Contains instead of Starts With
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

# Remove useless icons from Safari’s bookmarks bar
defaults write com.apple.Safari ProxiesInBookmarksBar "()"

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true


###############################################################################
# Messages                                                                    #
###############################################################################
# Disable smart quotes as it’s annoying for messages that contain code
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

# Required for OSX Mavericks: update the cfprefs cache from disk.
killall -u `whoami` cfprefsd
killall Finder
killall Safari


