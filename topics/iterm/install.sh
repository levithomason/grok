#!/usr/bin/env bash
#
# iTerm2
#
# Adds word/line navigation to every iTerm profile:
#   opt + left/right   jump word          (esc b / esc f)
#   cmd + left/right   jump to line ends  (ctrl-a / ctrl-e)
#
# Out of the box iTerm eats cmd+arrow for tab switching and sends opt+arrow as
# a sequence zsh doesn't bind. Profile key mappings win over both.
#
# Prefs are round-tripped through `defaults export/import` so cfprefsd stays
# in sync. Restart iTerm to pick up the change.

BUNDLE="com.googlecode.iterm2"
TMP="$(mktemp -d -t grok-iterm)"
PLIST="$TMP/iterm.plist"
BUDDY=/usr/libexec/PlistBuddy

# key (0xf702 left, 0xf703 right; 0x280000 opt, 0x300000 cmd) | action | text
# action 10 = send escape sequence, 11 = send hex code
MAPPINGS=(
  "0xf702-0x280000|10|b"
  "0xf703-0x280000|10|f"
  "0xf702-0x300000|11|0x01"
  "0xf703-0x300000|11|0x05"
)

if [ ! -d "/Applications/iTerm.app" ]; then
  echo "... iTerm.app not installed yet, skipping (will retry on next pass)"
elif ! defaults export "$BUNDLE" "$PLIST" 2>/dev/null \
  || ! $BUDDY -c "Print :'New Bookmarks':0:Guid" "$PLIST" >/dev/null 2>&1; then
  echo "... iTerm has no profiles yet, launch it once then re-run grok"
else
  echo "... mapping opt/cmd + arrows to word/line navigation"

  i=0
  while $BUDDY -c "Print :'New Bookmarks':$i:Guid" "$PLIST" >/dev/null 2>&1; do
    MAP=":'New Bookmarks':$i:'Keyboard Map'"
    $BUDDY -c "Add $MAP dict" "$PLIST" 2>/dev/null

    for mapping in "${MAPPINGS[@]}"; do
      IFS='|' read -r key action text <<< "$mapping"
      $BUDDY -c "Delete $MAP:$key" "$PLIST" 2>/dev/null
      $BUDDY \
        -c "Add $MAP:$key dict" \
        -c "Add $MAP:$key:Action integer $action" \
        -c "Add $MAP:$key:Text string $text" \
        "$PLIST"
    done

    i=$((i + 1))
  done

  defaults import "$BUNDLE" "$PLIST"

  pgrep -x iTerm2 >/dev/null && echo "... restart iTerm to apply"
fi

rm -rf "$TMP"
