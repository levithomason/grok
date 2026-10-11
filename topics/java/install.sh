#!/usr/bin/env bash
#
# Java
#
# openjdk@21 itself comes from Homebrew (installed_clis.txt). It is keg-only,
# so path.zsh puts it on PATH for the shell. Apps that run the macOS
# /usr/bin/java stub (or call /usr/libexec/java_home) look only in
# /Library/Java/JavaVirtualMachines, so link the JDK in there too.

BREW_JDK="$(brew --prefix openjdk@21 2>/dev/null)/libexec/openjdk.jdk"
SYSTEM_JDK="/Library/Java/JavaVirtualMachines/openjdk-21.jdk"

if [ ! -d "$BREW_JDK" ]; then
  echo "... openjdk@21 not installed via brew yet, skipping (will retry on next pass)"
elif [ -e "$SYSTEM_JDK" ]; then
  echo "... openjdk@21 already linked into JavaVirtualMachines"
else
  echo "... linking openjdk@21 into JavaVirtualMachines (needs sudo)"
  sudo ln -sfn "$BREW_JDK" "$SYSTEM_JDK"
fi
