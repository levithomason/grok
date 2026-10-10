#!/bin/zsh

#
# Install CLIs
#

echo "... installing CLI tools"

# Install what's missing; leave what's already here alone. Upgrades are a
# deliberate `brew upgrade`, not a side effect of re-running bootstrap.
HOMEBREW_NO_INSTALL_UPGRADE=1 brew install --formula $(cat $GROK_INSTALLED_CLIS)
