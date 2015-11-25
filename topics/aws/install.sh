#!/usr/bin/env bash

if hash aws 2>/dev/null; then
  sudo pip install --upgrade awscli
else
  sudo pip install awscli
fi
