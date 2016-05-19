#!/usr/bin/env zsh

# init according to man page
if (( $+commands[rbenv] )) then
  eval "$(rbenv init -)"
fi
