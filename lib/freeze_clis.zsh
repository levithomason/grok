#!/bin/zsh

#
# Freeze CLI tools
#

rm $GROK_LIB/installed_clis.txt
brew list --formula > $GROK_LIB/installed_clis.txt
