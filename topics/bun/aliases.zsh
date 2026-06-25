alias bi='bun install'
alias ba=fnBunAdd
alias bad=fnBunAddDev
alias br='bun remove'
alias bx='bun x'
alias brun='bun run'
alias bd='bun run dev'
alias bs='bun run start'
alias bt='bun test'
alias btw='bun test --watch'
alias bb='bun run build'

fnBunAdd() {
  bun add "$@"
}

fnBunAddDev() {
  bun add "$@" --dev
}
