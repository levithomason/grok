#!/usr/bin/env bash

###############################################################################
# Time Machine                                                                #
###############################################################################

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Disable local Time Machine backups
# Tahoe 26.5 - `disablelocal` is not a recognized verb
# hash tmutil &> /dev/null && sudo tmutil disablelocal
