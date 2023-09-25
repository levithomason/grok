#!/bin/zsh

[[ -n $GROK_DEBUG ]] && echo 'GROK: updating'

###############################################################################
# UPDATE
#
# Pull changes, run installs, run dotfiles

# pull latest repo
. $GROK_LIB/pull_latest_grokfiles.zsh

# install topics and run dotfiles
. $GROK_LIB/run_topic_installs.zsh
. $GROK_LIB/run_topic_zsh_files.zsh
