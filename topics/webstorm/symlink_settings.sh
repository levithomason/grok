#!/usr/local/bin/env bash

##############################################################################
# SYMLINK SETTINGS
#
# Symlinks WebStorm plugins and settings into DropBox
# https://www.jetbrains.com/webstorm/help/project-and-ide-settings.html
#

##############################################################################
# DEFINE FUNCTIONS
#
dropbox_dir=~/Dropbox
dropbox_webstorm_dir=$dropbox_dir/JetBrains/WebStorm

webstorm_plugins_dirs=(~/Library/Preferences/WebStorm*)
webstorm_settings_dirs=(~/Library/Application\ Support/WebStorm*)

#
# Link
#
link_and_remove_dir() {
  src=$2
  dst="$1";

  echo ""
  echo "... backing up "$dst""
  mv "$dst" "${dst/WebStorm/ws}".backup

  echo "... removing "$dst""
  rm -rf "$dst"

  echo "... symlinking "$src" to "$dst""
  ln -s "$src" "$dst"
}

symlink_dropbox_to_webstorm() {
  echo "... symlinking"

  # plugins
  echo "...    plugins"
  for dir in "${webstorm_plugins_dirs[@]}"; do
    echo "...      - $(basename "$dir")"
    link_and_remove_dir "$dir" "$dropbox_webstorm_dir/$(basename "$dir")"/plugins
  done

  # all other settings
  echo "...    settings"
  for dir in "${webstorm_settings_dirs[@]}"; do
    echo "...      - $(basename "$dir")"
    link_and_remove_dir "$dir" "$dropbox_webstorm_dir/$(basename "$dir")"/settings
  done
}

prompt_copy_current_to_dropbox() {
  echo ""
  echo "   Found:   "$dropbox_dir""
  echo "   Missing: "$dropbox_webstorm_dir""
  echo ""
  read -p "   Create missing dir and upload current settings? [y/N] " -n 1 action
  echo ""

  if [[ $action =~ ^[Yy]$ ]]; then
    echo ""

    # directory
    echo "...   creating directory"
    mkdir -p "$dropbox_webstorm_dir"                # create DropBox directory 

    # plugins
    echo "...   copying plugins"
    for dir in "${webstorm_plugins_dirs[@]}"; do    # loop array, accounts for spaces
      cp -r "$dir" "$dropbox_webstorm_dir"/plugins
    done
  
    # settings
    echo "...   copying settings"
    for dir in "${webstorm_settings_dirs[@]}"; do   # loop array, accounts for spaces
      cp -r "$dir" "$dropbox_webstorm_dir"/settings
    done

    symlink_dropbox_to_webstorm
  else
    echo ""
    echo "... skipped WebStorm symlink"
    echo ""
  fi
}

##############################################################################
# SYMLINK FILES
#

if [ ! -d $dropbox_dir ]
then
  echo "... Cannot find "$dropbox_dir""
else
  if [ ! -d $dropbox_webstorm_dir ] 
  then
    prompt_copy_current_to_dropbox
  else
    symlink_dropbox_to_webstorm
  fi
fi
