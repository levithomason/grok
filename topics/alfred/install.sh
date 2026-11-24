#!/usr/bin/env bash
#
# Alfred
#
# Replaces Spotlight for quick search: ⌘Space opens Alfred, macOS Dark theme,
# no hat logo, folders in results, no web fallbacks (Google/Amazon/Wikipedia),
# and the calculator ignores thousands separators in what you type.
#
# The files under preferences/ mirror Alfred.alfredpreferences/preferences.
# Alfred keeps per-machine settings (hotkey, theme) under local/<localhash>/,
# where localhash comes from Alfred/prefs.json, so local/ is copied there.

APP="/Applications/Alfred 6.app"
SRC="$GROK_TOPICS/alfred/preferences"
SUPPORT="$HOME/Library/Application Support/Alfred"
PREFS_JSON="$SUPPORT/prefs.json"

if [ ! -d "$APP" ]; then
  echo "... Alfred not installed yet, skipping config (will retry on next pass)"
  return 0 2>/dev/null || exit 0
fi

command -v jq >/dev/null || brew install jq

# Alfred writes prefs.json (with the localhash) on first launch
if [ ! -f "$PREFS_JSON" ]; then
  echo "... launching Alfred once to create its preferences"
  open -g -a "$APP"
  for _ in $(seq 1 20); do [ -f "$PREFS_JSON" ] && break; sleep 0.5; done
fi

if [ ! -f "$PREFS_JSON" ]; then
  echo "!!! $PREFS_JSON not found, skipping Alfred config"
  return 0 2>/dev/null || exit 0
fi

BUNDLE=$(jq -r '.current' "$PREFS_JSON")
LOCALHASH=$(jq -r '.localhash' "$PREFS_JSON")
DEST="$BUNDLE/preferences"

echo "... writing Alfred preferences"
osascript -e 'quit app "Alfred Preferences"' -e 'quit app "Alfred"' 2>/dev/null

for dir in "$SRC"/*/; do
  name=$(basename "$dir")
  if [ "$name" = local ]; then
    target="$DEST/local/$LOCALHASH"
  else
    target="$DEST/$name"
  fi
  mkdir -p "$target"
  cp -R "$dir" "$target/"
done

# Give ⌘Space to Alfred: turn off Spotlight's "Show Spotlight search" (id 64)
echo "... disabling Spotlight's ⌘Space shortcut"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 \
  "<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>1048576</integer></array><key>type</key><string>standard</string></dict></dict>"
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

open -g -a "$APP"
