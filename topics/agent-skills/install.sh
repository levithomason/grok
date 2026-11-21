#!/usr/bin/env bash
#
# agent-skills
#
# Makes the slash commands in commands/*.md available globally in both
# Claude Code and GitHub Copilot. commands/*.md are the canonical sources and
# are never modified.
#
#   Claude Code:  ~/.claude/commands/<name>.md  -> commands/<name>.md
#   Copilot:      ~/.agents/skills/<name>       -> build/<name> (generated)
#
# Copilot skills need a `name:` field and don't expand $ARGUMENTS, so a
# SKILL.md adapter is generated into build/ (gitignored) from each command.
#
# Anything already at a destination is replaced only if it's a symlink or has
# identical content; otherwise it's moved to ~/.agent-skills-backup/<time>/
# (outside every skill path, so it can't load as a duplicate). Sourced by zsh
# in run_topic_installs, so keep this bash + zsh compatible.

AGENT_SKILLS_TOPIC="$GROK_TOPICS/agent-skills"
AGENT_SKILLS_BACKUP="$HOME/.agent-skills-backup/$(date +%Y%m%d-%H%M%S)"
AGENT_SKILLS_ARGS_TEXT="Apply this to the user's supplied topic or arguments. If none are supplied, use the current conversation."
agent_skills_failed=

agent_skills_fail() {
  echo "!!! agent-skills: $*"
  agent_skills_failed=1
  return 1
}

agent_skills_same_content() {
  if [ -d "$1" ] && [ -d "$2" ]; then
    diff -rq "$1" "$2" >/dev/null 2>&1
  elif [ -f "$1" ] && [ -f "$2" ]; then
    cmp -s "$1" "$2"
  else
    return 1
  fi
}

# Move $1 out of the way into the backup dir under $2/.
agent_skills_backup() {
  local dst=$1 label=$2 backup
  backup="$AGENT_SKILLS_BACKUP/$label/$(basename "$dst")"
  mkdir -p "$(dirname "$backup")" &&
    mv "$dst" "$backup" ||
    { agent_skills_fail "could not back up $dst"; return 1; }
  echo "... backed up $dst to $backup"
}

# Symlink $1 at $2, clearing whatever is there safely first.
agent_skills_link() {
  local src=$1 dst=$2 label=$3

  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "... $dst already linked"
    return 0
  fi

  if [ -L "$dst" ] || [ -e "$dst" ]; then
    if [ -L "$dst" ] || agent_skills_same_content "$src" "$dst"; then
      rm -rf "$dst" || { agent_skills_fail "could not remove $dst"; return 1; }
    else
      agent_skills_backup "$dst" "$label" || return 1
    fi
  fi

  mkdir -p "$(dirname "$dst")" &&
    ln -s "$src" "$dst" ||
    { agent_skills_fail "could not link $dst"; return 1; }
  echo "... linked $dst"
}

# Write the Copilot SKILL.md adapter for command $1 into build/<name>/.
agent_skills_build() {
  local cmd=$1 name dir tmp
  name=$(basename "$cmd" .md)
  dir="$AGENT_SKILLS_TOPIC/build/$name"
  tmp="$dir/SKILL.md.tmp"

  mkdir -p "$dir" &&
    awk -v name="$name" -v args="$AGENT_SKILLS_ARGS_TEXT" '
      NR == 1 && $0 == "---" { print; print "name: " name; next }
      $0 == "$ARGUMENTS" { print args; next }
      { print }
    ' "$cmd" >"$tmp" &&
    mv "$tmp" "$dir/SKILL.md" ||
    { rm -f "$tmp"; agent_skills_fail "could not build $name skill"; return 1; }
}

for cmd in "$AGENT_SKILLS_TOPIC"/commands/*.md; do
  name=$(basename "$cmd" .md)

  # Claude Code: the exact original, as a user-level slash command.
  agent_skills_link "$cmd" "$HOME/.claude/commands/$name.md" claude-commands

  # Claude also loads ~/.claude/skills; a same-named skill there would
  # duplicate the command, so clear it (a symlink is just removed).
  claude_skill="$HOME/.claude/skills/$name"
  if [ -L "$claude_skill" ]; then
    rm -f "$claude_skill" &&
      echo "... removed duplicate link $claude_skill" ||
      agent_skills_fail "could not remove $claude_skill"
  elif [ -e "$claude_skill" ]; then
    agent_skills_backup "$claude_skill" claude-skills
  fi

  # Copilot: generated skill adapter.
  agent_skills_build "$cmd" &&
    agent_skills_link "$AGENT_SKILLS_TOPIC/build/$name" "$HOME/.agents/skills/$name" agents-skills
done

[ -z "$agent_skills_failed" ]
