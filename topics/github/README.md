# GitHub

Multiple GitHub accounts (e.g. personal + work) just work: `gh` and `git`
use the right one per repo, with nothing to set up per repo.

```sh
gh auth login -s workflow          # once per account (install.sh offers this)
```

How it works:

- GitHub remotes always use HTTPS. gitconfig rewrites `git@github.com:` and
  `ssh://git@github.com/` URLs to `https://github.com/`, so any clone URL works.
- `bin/gh` wraps the real `gh` and is also git's credential helper for
  github.com. It passes the chosen account's token (`GH_TOKEN`) to that one
  process; the active account is never switched.
- The account for a repo is its `git config gh.account`. If unset, `bin/gh`
  asks GitHub which logged-in account can push to the repo (else read it),
  uses it, and saves it as `gh.account`, printing one line when it does.
- Outside a repo: the repo named in the command (`-R owner/repo`,
  `gh repo view|clone owner/repo`), else the default in
  `~/.config/git/config` (machine-local; install.sh asks for it).
- When it can't decide (a new repo not on GitHub yet, several accounts can
  push, or none can see it), it exits with the commands to fix it, e.g.
  `git config gh.account <login>`.
- `gh auth login` / `setup-git` / `refresh` rewrite git's credential helper
  to the real `gh`; `bin/gh` puts itself back afterwards.
- Pushing `.github/workflows` over HTTPS needs the `workflow` scope. `bin/gh`
  prints the fix the first time a repo uses an account without it.
- One-off override: `GH_TOKEN=$(gh auth token -u <login>) gh ...` (or `git`).
