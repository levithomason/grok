#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Check for Homebrew
if test ! $(which brew)
then
  echo "  Installing Homebrew for you."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

###############################################################################
# Keep Healthy
#

echo "... updating brew"
brew update


###############################################################################
# Grok requirements
#

brew install \
  grc \
  coreutils \
  spark \
  caskroom/cask/brew-cask


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
