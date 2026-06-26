# Activate mise so it auto-switches tool versions (Bun, Node, etc.) whenever
# you cd into a repo with a .mise.toml — the nvm equivalent for the polyglot
# world. https://mise.jdx.dev
#
# Loads after homebrew/path.zsh, so `mise` is on $PATH once installed. Guard the
# activation so a machine that has pulled this topic but not yet run bootstrap
# (no mise binary) doesn't error on every shell start.
command -v mise &>/dev/null && eval "$(mise activate zsh)"
