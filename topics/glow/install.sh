#!/usr/bin/env bash
#
# glow
#
# Symlinks glow.yml into glow's config location so settings (120-col width)
# stay versioned here. glow's default config path is
# ~/Library/Preferences/glow/glow.yml — the repo's *.symlink convention only
# targets $HOME/.name, so we link the nested path by hand.

SRC="$GROK_TOPICS/glow/glow.yml"
DST="$HOME/Library/Preferences/glow/glow.yml"

mkdir -p "$(dirname "$DST")"

# Already linked to us? Nothing to do.
if [ "$(readlink "$DST")" = "$SRC" ]; then
  echo "... glow config already linked"
# Back up a real file (e.g. one written by `glow config`) before replacing it.
elif [ -e "$DST" ] && [ ! -L "$DST" ]; then
  echo "... backing up existing glow config to glow.yml.backup"
  mv "$DST" "$DST.backup"
  ln -s "$SRC" "$DST"
  echo "... linked glow config"
else
  rm -f "$DST"
  ln -s "$SRC" "$DST"
  echo "... linked glow config"
fi
