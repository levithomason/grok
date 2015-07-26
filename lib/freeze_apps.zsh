#!/bin/zsh

#
# Freeze desktop apps
#

rm $GROK_LIB/installed_apps.txt
brew cask list > $GROK_LIB/installed_apps.txt
