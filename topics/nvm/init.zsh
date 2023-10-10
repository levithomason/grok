# nvm init is terribly slow
# only load nvm when we need it

lazynvm() {
  unset -f nvm node npm yarn
  export NVM_SYMLINK_CURRENT=true
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
}

nvm() {
  lazynvm
  nvm "$@"
}

node() {
  lazynvm
  node "$@"
}

npm() {
  lazynvm
  npm "$@"
}

yarn() {
  lazynvm
  yarn "$@"
}

