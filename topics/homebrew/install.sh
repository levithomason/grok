#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Check for Homebrew
. $GROK_TOPICS/homebrew/install_if_needed.sh

###############################################################################
# Keep Healthy
#

echo "... updating brew"
brew update


###############################################################################
# Grok requirements
#

brew install --formula grc coreutils spark


###############################################################################
# User CLIs and apps
#

. $GROK_LIB/install_clis.zsh
. $GROK_LIB/install_apps.zsh

###############################################################################
# Post install health
#

echo "... pruning brew"
brew prune
