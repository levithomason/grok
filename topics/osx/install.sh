#!/usr/bin/env bash

# Inspired by
# ~/.osx — https://mths.be/osx

#
# Get Admin Upfront
#

sudo -v

# Keep-alive: update existing `sudo` time stamp until we're finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


#
# Run settings
#

for settings in $GROK_TOPICS/osx/settings/*; do
  echo "... running: $(basename "$settings")"
  source $settings;
done

#
# Restart Apps
#

for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
  "Dock" "Finder" "Mail" "Messages" "Safari" "SizeUp" "SystemUIServer" \
  "Transmission" "Twitter" "iCal"; do
  echo "... restarting $app"
  killall "${app}" > /dev/null 2>&1
done
echo "... Done. Kill Terminal and logout/restart to finish."
