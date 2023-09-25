if [[ -n $SSH_CONNECTION ]]; then
  export PS1='%m:%3~$(git_info_for_prompt)%# '
else
  export PS1='%3~$(git_info_for_prompt)%# '
fi

export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true

###############################################################################
# Functions & Completion
#
# http://zsh.sourceforge.net/Doc/Release/Functions.html

# compinit caches completions in ~/.zcompdump based on the contents of $fpath
# when reloading the shell, we need to only add new directories to $fpath
typeset -A seen_dirs
for dir in "${fpath[@]}"; do
  seen_dirs[$dir]=1
done

# remove directories from fpath if they no longer exist
clean_fpath() {
  local new_fpath=()
  for dir in "${fpath[@]}"; do
    if [[ -d $dir ]]; then
      new_fpath+=("$dir")
    else
      unset "seen_dirs[$dir]"
    fi
  done
  fpath=("${new_fpath[@]}")
}

# add a new directory to fpath if it's a dir and not already there
add_to_fpath_if_needed() {
  local dir="$1"
  if [[ -z $seen_dirs[$dir] && -d $dir ]]; then
    fpath+=("$dir")
    seen_dirs[$dir]=1
  fi
}

# add grok directories to fpath
add_to_fpath_if_needed $GROK_FUNCTIONS

for topic_folder in "$GROK_TOPICS"/*; do
  if [[ -d $topic_folder ]]; then
    add_to_fpath_if_needed "$topic_folder"
  fi
done

# init completion here, otherwise topic functions won't be loaded
autoload -U compinit
compinit # this should now be fast in reloading since we have a stable fpath

autoload -U $GROK_FUNCTIONS/*(:t)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt NO_BG_NICE           # don't nice background tasks
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS        # allow functions to have local options
setopt LOCAL_TRAPS          # allow functions to have local traps
setopt HIST_VERIFY
setopt SHARE_HISTORY        # share history between sessions ???
setopt EXTENDED_HISTORY     # add timestamps to history
setopt PROMPT_SUBST
setopt CORRECT
setopt COMPLETE_IN_WORD
setopt IGNORE_EOF

setopt APPEND_HISTORY # adds history
setopt INC_APPEND_HISTORY SHARE_HISTORY  # adds history incrementally and share it across sessions
setopt HIST_IGNORE_ALL_DUPS  # don't record dupes in history
setopt HIST_REDUCE_BLANKS

# don't expand aliases _before_ completion has finished
#   like: git comm-[tab]
setopt complete_aliases

zle -N newtab

bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word
bindkey '^[[5D' beginning-of-line
bindkey '^[[5C' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[^N' newtab
bindkey '^?' backward-delete-char
