#!/bin/sh

###############################################################################
# GROK
#
# These are private values used internally, best to leave them as is.

[[ -n $GROK_DEBUG ]] && echo 'GROK: set_env_variables'

export GROK_ROOT=$HOME/.grokfiles
export GROK_TOPICS=$GROK_ROOT/topics
export GROK_BIN=$GROK_ROOT/bin
export GROK_FUNCTIONS=$GROK_ROOT/functions
export GROK_LIB=$GROK_ROOT/lib
export GROK_INSTALLED_APPS=$GROK_LIB/installed_apps.txt
export GROK_INSTALLED_CLIS=$GROK_LIB/installed_clis.txt


###############################################################################
# USER
#
# Configure these to your liking

export GROK_PROJECTS=~/src
