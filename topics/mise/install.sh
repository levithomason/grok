#!/usr/bin/env bash
#
# mise
#
# Polyglot runtime version manager (replaces nvm here). Provisions and
# auto-switches the tool versions pinned in each repo's .mise.toml.
# https://mise.jdx.dev

set -e

if ! command -v mise &> /dev/null; then
  echo "  Installing mise for you."
  brew install mise
fi
