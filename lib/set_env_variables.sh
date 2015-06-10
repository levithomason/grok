#!/bin/sh

###############################################################################
# DOTFILES
#
# These are private values used internally, best to leave them as is.

echo 'GROK: set_env_variables'

export DOTFILES_ROOT=$HOME/.grokfiles
export DOTFILES_TOPICS=$DOTFILES_ROOT/topics
export DOTFILES_BIN=$DOTFILES_ROOT/bin
export DOTFILES_FUNCTIONS=$DOTFILES_ROOT/functions
export DOTFILES_LIB=$DOTFILES_ROOT/lib


###############################################################################
# USER
#
# Configure these to your liking

export DOTFILES_PROJECTS=~/src
