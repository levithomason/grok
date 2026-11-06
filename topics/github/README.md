# GitHub

`bin/gh` makes `gh` use the account set for the current repo:

```sh
gh auth login                      # once per account
git config gh.account <login>      # once per repo (stored in .git/config)
git config --file ~/.config/git/config gh.account <login>   # default outside repos
```

- One logged-in account: nothing to set; it's used.
- Several accounts and no `gh.account` for the repo: `gh` fails with these
  instructions, so agents and scripts never guess. Repos only use their own
  setting; the outside-repo default lives in `~/.config/git/config`, which is
  machine-local (unlike `~/.gitconfig`, which is in these dotfiles).
- One-off: `GH_TOKEN=$(gh auth token -u <login>) gh ...` (any `GH_TOKEN` /
  `GITHUB_TOKEN` already set is used as-is).
- The token is passed only to that `gh` process; the active account is never
  switched, so other terminals and agents are unaffected.
