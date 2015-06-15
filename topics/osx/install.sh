#!/usr/bin/env bash

for settings in $GROK_TOPICS/osx/settings/*; do
  echo "... running: $(basename "$settings")"
  source $settings;
done

# Kill affected applications
for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
  "Dock" "Finder" "Mail" "Messages" "Safari" "SizeUp" "SystemUIServer" \
  "Terminal" "Transmission" "Twitter" "iCal"; do
  echo "... restarting $app"
  killall "${app}" > /dev/null 2>&1
done
echo "... Done. Note that some of these changes require a logout/restart to take effect."

