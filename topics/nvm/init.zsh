export NVM_SYMLINK_CURRENT=true
export NVM_DIR="$HOME/.nvm"

# Sourcing nvm.sh normally runs `nvm use default`, which forks hundreds of
# processes. With endpoint security scanning every exec that costs 5s+ per
# shell. Load nvm without switching versions, and put the `current` symlink
# (kept up to date by `nvm use` via NVM_SYMLINK_CURRENT) on PATH instead, so
# node, npm and globals are available immediately.
if [ -s "$NVM_DIR/nvm.sh" ]; then
  if [ -x "$NVM_DIR/current/bin/node" ]; then
    . "$NVM_DIR/nvm.sh" --no-use
    export NVM_BIN="$NVM_DIR/current/bin"
    path=("$NVM_BIN" $path)
  else
    . "$NVM_DIR/nvm.sh"
  fi
fi
