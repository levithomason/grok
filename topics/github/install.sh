#!/usr/bin/env bash
#
# GitHub
#
# Ensures we're authenticated to GitHub. Required before any topic that clones
# a private repo, pushes changes, or relies on git remote access. `gh auth
# login` is interactive — it walks through HTTPS or SSH setup and can upload
# an SSH key for you.

if ! command -v gh >/dev/null; then
  echo "... gh CLI not installed yet, skipping github auth (will retry on next pass)"
elif gh auth status >/dev/null 2>&1; then
  echo "... github already authenticated"
else
  echo "... authenticating with github (interactive)"
  gh auth login
fi
