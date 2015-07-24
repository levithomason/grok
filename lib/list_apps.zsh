#!/bin/zsh

#
# List APPs
#

echo "================================================================================="
echo "  DESKTOP APPS"
echo ""
echo "    Installed"
for app in $(brew cask list); do
  echo "      $app"
done;

echo ""
echo "    Frozen"
for app in $(cat $GROK_INSTALLED_APPS); do
  echo "      $app"
done;
