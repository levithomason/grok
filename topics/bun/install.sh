#!/usr/bin/env bash

if test ! $(which bun); then
  echo "  Installing bun."
  # bun's own installer (not Homebrew) so `bun upgrade` works without the
  # "use brew upgrade instead" conflict. SHELL=sh forces the installer's
  # fallback branch, which prints the PATH lines instead of appending them to
  # ~/.zshrc — that file is symlinked into this repo. path.zsh owns PATH.
  curl -fsSL https://bun.com/install | SHELL=/bin/sh bash
fi
