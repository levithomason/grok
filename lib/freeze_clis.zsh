#!/bin/zsh

#
# Freeze CLI tools
#
command=$1
cli=$2

if [[ $command == "install" ]] then
  echo $cli >> $GROK_LIB/installed_clis.txt
fi

if [[ $command == "uninstall" ]] then
  grep -x -v $cli $GROK_LIB/installed_clis.txt > $GROK_LIB/tmp
  mv $GROK_LIB/tmp $GROK_LIB/installed_clis.txt
fi

# sort and remove duplicates
sort -uo $GROK_LIB/installed_clis.txt $GROK_LIB/installed_clis.txt
