#!/bin/zsh

#
# Freeze desktop apps
#

rm $GROK_LIB/installed_apps.txt
brew list --cask > $GROK_LIB/installed_apps.txt
