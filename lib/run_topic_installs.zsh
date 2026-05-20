#!/bin/zsh

[[ -n $GROK_DEBUG ]] && echo 'GROK: run_topic_installs'

###############################################################################
# DEFINE INSTALL FUNCTIONS
#

log_header() {
  echo ''
  echo '==============================================================================='
  echo 'INSTALL TOPIC:' $*
  echo '==============================================================================='
}

###############################################################################
# ENSURE PREREQUISITES
#
# Homebrew is a hard dep for most topics (anything that shells out to `brew`).
# Bootstrap it first so topic order doesn't matter.
#
source $GROK_TOPICS/homebrew/install_if_needed.sh

###############################################################################
# RUN TOPIC INSTALL SCRIPTS
#
# Homebrew runs first so app/cli installs happen before topics that depend on
# them. Remaining topics run in filesystem order.
#

HOMEBREW_INSTALLER="$GROK_TOPICS/homebrew/install.sh"

if [ -f "$HOMEBREW_INSTALLER" ]; then
  log_header homebrew
  source "$HOMEBREW_INSTALLER"
fi

for installer in $(find $GROK_TOPICS -name install.sh -not -path "$HOMEBREW_INSTALLER"); do
  log_header $(basename ${installer/\/install.sh});
  source $installer;
done
