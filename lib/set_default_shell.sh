#!/bin/bash

#
# Set default shell zsh if not already
#

if [ "$SHELL" != "/bin/zsh" ]
then
  chsh -s $(which zsh)
else
  echo "  ZSH is already the default shell"
fi
