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
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" > /tmp/homebrew-install.log
fi

###############################################################################
# Keep Healthy
#

echo "... updating brew"
brew update


###############################################################################
# Dotfile packages
#

brew install \
  grc \
  coreutils \
  spark \
  caskroom/cask/brew-cask


###############################################################################
# User apps
#

# CLI tools
echo "... installing cli tools"

brew install \
 nodenv

echo "... installing desktop apps"

# Desktop apps
brew cask install \
  1password \
  dropbox \
  google-chrome \
  google-drive \
  java \
  quicksilver \
  webstorm


###############################################################################
# Post install health
#

echo "... pruning brew"
brew prune
