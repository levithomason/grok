#!/usr/bin/env bash

# install virtualenvwrapper
if test ! $(which virtualenvwrapper); then
  echo "...Installing virtualenvwrapper"
  pip install virtualenvwrapper
fi
