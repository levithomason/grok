#!/usr/bin/env bash

if test ! $(which yarn); then
  echo "  Installing yarn."
  brew install yarn
fi
