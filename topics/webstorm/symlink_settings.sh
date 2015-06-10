#!/usr/local/bin/env bash
#
# SYMLINK SETTINGS
#
# https://www.jetbrains.com/ws/help/project-and-ide-settings.html
#
# This script symlinks local WebStorm settings to DropBox. If DropBox is not
# found, the script exists.  If DropBox is found, but the settings to symlink
# are not, you'll be prompted to backup, upload, and and link your current
# WebStorm directories to DropBox.  Future machines will link to the newly
# created DropBox settings.
#


##############################################################################
# DEFINE FUNCTIONS
#

db_dir=~/Dropbox
db_grok_dir=$db_dir/grok
db_ws_plugins_dir=$db_grok_dir/webstorm/plugins
db_ws_settings_dir=$db_grok_dir/webstorm/settings

# array of all WebStorm* directories, prune children
# ignore *.backup directories, previously created by the script 
ws_plugins_dirs=$(find -L ~/Library/Preferences/WebStorm* -type d -prune -not -name *.backup)
ws_settings_dirs=$(find -L ~/Library/Application\ Support/WebStorm* -type d -prune -not -name *.backup)

#
# Link
#

backup_and_link() {
  local db="$1";
  local ws="$2";
  local ws_ver="$(basename "$ws")";

  # get either plugins/settings folder name from dropbox path
  #   .../grok/WebStorm/plugins/WebStormX == plugins
  #   .../grok/WebStorm/settings/WebStormX == settings
  local type="$(basename $(dirname "$db"))";

  local ws_dest="$(readlink "$ws")"       # check if ws_src is already a link

  if [ "$ws_dest" == "$db" ]; then        # skip if already linked to dropbox
    echo "... "$ws_ver" "$type" already linked"
  else                                    # ws_src not already linked
    echo "... backing up:"
    echo "      "$ws""
    echo "      "$ws".backup"
    mv "$ws" "$ws.backup"                 # back up ws_src

    echo "... symlinking:"
    echo "      "$db""
    echo "      "$ws""
    ln -s "$db" "$ws"                     # link from dropbox to ws_src
  fi
}

symlink_db_to_ws() {
  # plugins
  for ws_dir in "${ws_plugins_dirs[@]}"; do
    ws_version=$(basename "$ws_dir");
    db_dir="$db_ws_plugins_dir/$ws_version"

    backup_and_link "$db_dir" "$ws_dir"
  done

  # all other settings
  for ws_dir in "${ws_settings_dirs[@]}"; do
    ws_version=$(basename "$ws_dir");
    db_dir="$db_ws_settings_dir/$ws_version"

    backup_and_link "$db_dir" "$ws_dir"
  done
}

#
# Prompt to create
#

prompt_create_upload_current_to_db() {
  echo ""
  read -p "   Create missing dir and upload current settings? [y/N] " -n 1 SHOULD_CREATE
  echo ""

  if [[ $SHOULD_CREATE =~ ^[Yy]$ ]]; then
    echo ""

    echo "...  create plugins dir"
    mkdir -p "$db_ws_plugins_dir"             # create DropBox plugins dir 

    echo "...  create settings dir"
    mkdir -p "$db_ws_settings_dir"            # create DropBox settings dir 

    echo "...  upload plugins"
    for dir in "${ws_plugins_dirs[@]}"; do    # upload plugins to DropBox
      cp -r "$dir" "$db_ws_plugins_dir"
    done

    echo "...  upload settings"
    for dir in "${ws_settings_dirs[@]}"; do   # upload settings to DropBox
      cp -r "$dir" "$db_ws_settings_dir"
    done

    symlink_db_to_ws                          # symlink DropBox to local
  else
    echo ""
    echo "... skipping, WebStorm symlink"
    echo ""
  fi
}

##############################################################################
# SYMLINK FILES
#

# no dropbox, exit
if [ ! -d $db_dir ]; then
  echo "... skipping, cannot find "$db_dir""
else
  if [ ! -d $db_ws_plugins_dir ] && [ ! -d $db_ws_settings_dir ]; then
    echo "... missing plugins/settings directories:"
    echo "      "$db_ws_plugins_dir""
    echo "      "$db_ws_settings_dir""

    prompt_create_upload_current_to_db
  else
    echo "... found DropBox plugins/settings"

    symlink_db_to_ws
  fi
fi
