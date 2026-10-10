#!/usr/bin/env bash
#
# nvm
#
# nvm itself comes from Homebrew (installed_clis.txt). Its NVM_DIR lives
# outside the Cellar so installed node versions survive brew upgrades; init.zsh
# sources $NVM_DIR/nvm.sh, so link brew's scripts in there.

NVM_DIR="$HOME/.nvm"
BREW_NVM="$(brew --prefix nvm 2>/dev/null)/libexec"

if [ ! -f "$BREW_NVM/nvm.sh" ]; then
  echo "... nvm not installed via brew yet, skipping (will retry on next pass)"
else
  mkdir -p "$NVM_DIR"
  for script in nvm.sh nvm-exec; do
    [ -e "$NVM_DIR/$script" ] || ln -s "$BREW_NVM/$script" "$NVM_DIR/$script"
  done
  echo "... nvm ready at $NVM_DIR"
fi
