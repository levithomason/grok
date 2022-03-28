#!/bin/zsh

#
# List CLIs
#

echo "================================================================================="
echo "  CLI TOOLS"
echo ""
echo "    Installed"
for cli in $(brew list --formula); do
  echo "      $cli"
done;

echo ""
echo "    Frozen"
for cli in $(cat $GROK_INSTALLED_CLIS); do
  echo "      $cli"
done;
