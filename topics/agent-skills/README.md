# Agent skills

Global `/terse` and `/check` for Claude Code and GitHub Copilot.

`commands/*.md` are the source. They are byte-identical copies of
`delta-neutral/.claude/commands/{terse,check}.md`; edit them here and copy
back if they need to stay in sync.

`install.sh` (run by `grok`/`bootstrap`) sets up:

- Claude Code: `~/.claude/commands/<name>.md` → `commands/<name>.md`
  (the exact file, including `$ARGUMENTS`).
- Copilot: `~/.agents/skills/<name>` → `build/<name>`. Copilot skills need a
  `name:` field and don't expand `$ARGUMENTS`, so install generates a
  `SKILL.md` adapter in `build/` (gitignored) that adds `name:` and replaces
  `$ARGUMENTS` with a plain instruction. The adapter is not identical to the
  source.

Install is safe to re-run. Other skills and commands are left alone. If a
destination already holds something different, it's moved to
`~/.agent-skills-backup/<time>/` first. A same-named entry in
`~/.claude/skills/` is cleared so Claude doesn't load the command twice.
Failures print `!!! agent-skills: ...` and the topic exits non-zero.
