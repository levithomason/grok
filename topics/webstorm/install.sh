#!/usr/bin/env bash
set -e

# install TextMate bundle for Python syntax highlighting
if ! [ -d ~/src/python.tmbundle ]; then
  git clone git@github.com:textmate/python.tmbundle.git ~/src/python.tmbundle
else
  echo "TextMate Python bundle already cloned to ~/src, skipping..."
fi
