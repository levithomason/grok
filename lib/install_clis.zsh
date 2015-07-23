#!/bin/zsh

#
# Install CLIs
#

echo "... installing CLI tools"

for cli in $(cat $GROK_INSTALLED_CLIS); do
 brew install $cli
done
