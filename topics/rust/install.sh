#!/usr/bin/env bash

if test ! $(which rustc); then
  echo "  Installing rust."
  # rustup's own installer (not Homebrew) so `rustup update` manages toolchains
  # without a package-manager conflict. -y skips the prompts; --no-modify-path
  # stops it from writing `. "$HOME/.cargo/env"` into ~/.profile, ~/.zshenv, and
  # ~/.tcshrc — path.zsh owns PATH here.
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi
