#!/usr/bin/env bash

# install virtualenv
if test ! "$(python3 -m virtualenv --version)"; then
  echo "...Installing virtualenv"
  python3 -m pip install --upgrade pip
  python3 -m pip install --upgrade virtualenv
fi