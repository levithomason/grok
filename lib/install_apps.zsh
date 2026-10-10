#!/bin/zsh

#
# Install apps
#

echo "... installing desktop apps"

# Install what's missing; leave what's already here alone. Upgrades are a
# deliberate `brew upgrade`, not a side effect of re-running bootstrap.
#
# --adopt takes over an app already in /Applications that brew didn't install,
# so every listed app ends up brew-managed. If the existing app doesn't match
# the cask, brew errors on that app, leaves it untouched, and installs the rest.
HOMEBREW_NO_INSTALL_UPGRADE=1 brew install --cask --adopt $(cat $GROK_INSTALLED_APPS)
