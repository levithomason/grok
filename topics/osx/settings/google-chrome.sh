#!/usr/bin/env bash

###############################################################################
# Google Chrome & Google Chrome Canary                                        #
###############################################################################

# Allow installing user scripts via GitHub Gist or Userscripts.org
defaults write com.google.Chrome ExtensionInstallSources -array "https://gist.githubusercontent.com/" "http://userscripts.org/*"
defaults write com.google.Chrome.canary ExtensionInstallSources -array "https://gist.githubusercontent.com/" "http://userscripts.org/*"

# Disable the all too sensitive backswipe
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false
