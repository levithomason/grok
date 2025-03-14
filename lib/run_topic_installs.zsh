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
# RUN TOPIC INSTALL SCRIPTS
#
# Run all `install.sh` files in `\topics`.
#

# find the installers and run them iteratively
for installer in $(find $GROK_TOPICS -name install.sh); do
  log_header $(basename ${installer/\/install.sh});
  source $installer;
done
