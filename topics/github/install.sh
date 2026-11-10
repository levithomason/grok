#!/usr/bin/env bash
#
# GitHub
#
# Ensures we're authenticated to GitHub. Required before any topic that clones
# a private repo, pushes changes, or relies on git remote access.
#
# Every account (e.g. personal + work) is logged in with `gh auth login`;
# bin/gh then picks the right one per repo for gh and git (see README.md).
# Logins go through bin/gh so git's credential helper stays pointed at it.

gh="$HOME/.grokfiles/bin/gh"
local_config="$HOME/.config/git/config"

logins() {
  sed -n 's/^        \([^ #][^:]*\):.*/\1/p' "$HOME/.config/gh/hosts.yml" 2>/dev/null
}

if ! "$gh" --version >/dev/null 2>&1; then
  echo "... gh CLI not installed yet, skipping github auth (will retry on next pass)"
  exit 0
fi

if [ -z "$(logins)" ]; then
  echo "... authenticating with github (interactive)"
  "$gh" auth login -s workflow
  while read -r -p "... log in another GitHub account (e.g. work)? (y/N) " reply && [[ $reply =~ ^[Yy] ]]; do
    "$gh" auth login -s workflow
  done
else
  echo "... github authenticated: $(echo $(logins))"
  echo "    (another account? 'gh auth login -s workflow')"
fi

# Default account for gh outside repos (machine-local, not in these dotfiles).
if [ "$(logins | grep -c .)" -gt 1 ] && [ -z "$(git config --file "$local_config" gh.account)" ]; then
  first=$(logins | head -1)
  read -r -p "... default GitHub account outside repos [$first]: " choice
  mkdir -p "$(dirname "$local_config")"
  git config --file "$local_config" gh.account "${choice:-$first}"
fi

# Pushing .github/workflows over https needs the workflow scope.
default=$(git config --file "$local_config" gh.account)
for u in $(logins); do
  scopes=$(GH_TOKEN=$("$gh" auth token -u "$u") "$gh" api -i user 2>/dev/null | tr -d '\r' |
    sed -n 's/^[Xx]-[Oo][Aa]uth-[Ss]copes: //p')
  case ", $scopes," in
    ", ,"|*", workflow,"*) ;;
    *) echo "... $u can't push workflow files yet. To allow it:"
       echo "    gh auth switch -u $u && gh auth refresh -s workflow && gh auth switch -u ${default:-$u}" ;;
  esac
done
