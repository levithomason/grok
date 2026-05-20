#!/usr/bin/env bash

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Set computer name (as done via System Preferences → Sharing)
# sudo scutil --set ComputerName "0x6D746873"
# sudo scutil --set HostName "0x6D746873"
# sudo scutil --set LocalHostName "0x6D746873"
# sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "0x6D746873"

# Set standby delay to 24 hours (default is 1 hour)
# sudo pmset -a standbydelay 86400

# Disable the sound effects on boot
# sudo nvram SystemAudioVolume=" "

# Menu bar: disable transparency
# defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false

# Set highlight color to green
# defaults write NSGlobalDomain AppleHighlightColor -string "0.764700 0.976500 0.568600"

# Set sidebar icon size to medium
# defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

# Always show scrollbars
# Possible values: `WhenScrolling`, `Automatic` and `Always`
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Increase window resize speed for Cocoa applications
# defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Expand save panel by default
# defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
# defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
# defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
# defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
# defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Automatically quit printer app once the print jobs complete
# defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable the “Are you sure you want to open this application?” dialog
# defaults write com.apple.LaunchServices LSQuarantine -bool false

# Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
# /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# Display ASCII control characters using caret notation in standard text views
# Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
# defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

# Disable Resume system-wide
# defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false

# Disable automatic termination of inactive apps
# defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Disable the crash reporter
# defaults write com.apple.CrashReporter DialogType -string "none"

# Set Help Viewer windows to non-floating mode
# defaults write com.apple.helpviewer DevMode -bool true

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
# sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Never go into computer sleep mode
# sudo systemsetup -setcomputersleep Off > /dev/null

# Check for software updates daily, not just once per week
# defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Disable smart quotes as they’re annoying when typing code
# defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
# defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

