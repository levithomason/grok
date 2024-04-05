alias yi='yarn install'
alias ya=fnYarnAdd
alias yad=fnYarnAddDev
alias yd='yarn dev'
alias yr='yarn remove'
alias ys='yarn start'
alias ysw='yarn start:watch'
alias yt='yarn test'
alias ytw='yarn test:watch'
alias yl='yarn lint'
alias ylf='yarn lint:fix'
alias ylw='yarn lint:watch'
alias yb='yarn build'
alias ybw='yarn build:watch'
alias yfr='yarn file:run'
alias yfw='yarn file:watch'

fnYarnAdd() {
  yarn add "$@"
}

fnYarnAddDev() {
  yarn add "$@" --dev
}