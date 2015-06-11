#!/usr/bin/env bash
#
# nodenv
#
# Setup nodenv 
#

###############################################################################
# DEFINE FUNCTIONS
#

install_default_versions() {
  nodenv install v0.12.4
  nodenv global v0.12.4
}

###############################################################################
# INSTALL
#

# Check for nodenv
if test ! $(which nodenv); then
  echo "  nodenv is not installed. Add it to the homebrew install.sh"
else
  install_default_versions
fi

