#!/bin/zsh

#
# Freeze desktop apps
#
command=$1
app=$2

if [[ $command == "install" ]] then
  echo $app >> $GROK_LIB/installed_apps.txt
fi

if [[ $command == "uninstall" ]] then
  grep -x -v $app $GROK_LIB/installed_apps.txt > $GROK_LIB/tmp
  mv $GROK_LIB/tmp $GROK_LIB/installed_apps.txt
fi

# sort and remove duplicates
sort -uo $GROK_LIB/installed_apps.txt $GROK_LIB/installed_apps.txt
