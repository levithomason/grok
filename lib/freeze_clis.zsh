#!/bin/zsh

#
# Freeze CLI tools
#

rm $GROK_LIB/installed_clis.txt
brew list > $GROK_LIB/installed_clis.txt
