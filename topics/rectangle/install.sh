#!/usr/bin/env bash
#
# Rectangle
#
# Imports rectangle-config.json into Rectangle's preferences.
# The JSON is Rectangle's native export format (bundleId/defaults/shortcuts);
# we translate it into `defaults write` calls so no UI dialog pops up.

CONFIG="$GROK_TOPICS/rectangle/rectangle-config.json"
BUNDLE="com.knollsoft.Rectangle"

if [ ! -d "/Applications/Rectangle.app" ]; then
  echo "... Rectangle.app not installed yet, skipping config (will retry on next pass)"
elif [ ! -f "$CONFIG" ]; then
  echo "... missing $CONFIG, skipping"
else
  command -v jq >/dev/null || brew install jq

  echo "... importing Rectangle config"

  # defaults — skip empty dicts (e.g. disabledApps, footprintColor) that have no typed value
  jq -r '.defaults | to_entries[]
    | select((.value | type) == "object" and (.value | length) > 0)
    | "\(.key)\t\(.value | keys[0])\t\(.value | .[keys[0]])"' "$CONFIG" \
  | while IFS=$'\t' read -r key type val; do
      defaults write "$BUNDLE" "$key" "-$type" "$val"
    done

  # shortcuts — write as plist dict literal
  jq -r '.shortcuts | to_entries[]
    | "\(.key)\t{keyCode=\(.value.keyCode);modifierFlags=\(.value.modifierFlags);}"' "$CONFIG" \
  | while IFS=$'\t' read -r key dict; do
      defaults write "$BUNDLE" "$key" "$dict"
    done

  # Flush prefs cache so Rectangle picks up new values
  killall cfprefsd 2>/dev/null

  # Only relaunch if it was already running — first-time launch needs the user
  # to grant Accessibility permissions interactively.
  if pgrep -x Rectangle >/dev/null; then
    killall Rectangle 2>/dev/null
    open -a Rectangle
  fi
fi
