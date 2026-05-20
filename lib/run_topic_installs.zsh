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
# Ordered prerequisites run first so later topics can depend on them:
#   homebrew  → installs `gh` and other CLIs/apps used downstream
#   github    → `gh auth login` so private clones / pushes work
# Remaining topics then run in filesystem order.
#

HOMEBREW_INSTALLER="$GROK_TOPICS/homebrew/install.sh"
GITHUB_INSTALLER="$GROK_TOPICS/github/install.sh"

for installer in "$HOMEBREW_INSTALLER" "$GITHUB_INSTALLER"; do
  if [ -f "$installer" ]; then
    log_header $(basename ${installer:h})
    source "$installer"
  fi
done

for installer in $(find $GROK_TOPICS -name install.sh \
  -not -path "$HOMEBREW_INSTALLER" \
  -not -path "$GITHUB_INSTALLER"); do
  log_header $(basename ${installer/\/install.sh});
  source $installer;
done
