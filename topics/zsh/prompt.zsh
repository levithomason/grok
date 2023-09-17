autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

git_find_root() {
  local dir="$PWD"
  while [[ "$dir" != "" && ! -d "$dir/.git" ]]; do
    dir="${dir%/*}"
  done
  echo "$dir"
}

git_root_prompt() {
  local git_root=$(git_find_root)
  if [[ -n "$git_root" ]]; then
    local root_name=$(basename "$git_root")

    echo "\e[2m${root_name}\e[0m "
  else
    echo ""
  fi
}

git_branch () {
  ref=$($git symbolic-ref HEAD 2>/dev/null) || return
  echo "${ref#refs/heads/}"
}

git_dirty_prompt() {
  if git diff --quiet && git diff --cached --quiet; then
    # Working directory clean
    echo " on %{$fg_bold[green]%}$(git_branch)%{$reset_color%}"
  else
    # Changes staged or unstaged
    echo " on %{$fg_bold[red]%}$(git_branch)%{$reset_color%}"
  fi
}

unpushed () {
  $git cherry -v @{upstream} 2>/dev/null
}

need_push_prompt () {
  if [[ $(unpushed) == "" ]]
  then
    echo " "
  else
    echo " with %{$fg_bold[magenta]%}unpushed%{$reset_color%}"
  fi
}

directory_prompt() {
  echo "%{$fg_bold[cyan]%}%1/%\/%{$reset_color%}"
}

venv_prompt() {
  if ! [[ -z ${VIRTUAL_ENV} ]]; then
    local env=$(basename $VIRTUAL_ENV)
    echo "%{$fg[green]%}[$env]%{$reset_color%} "
  fi
}

set_prompt () {
  local directory=$(directory_prompt)
  export PROMPT="$directory"

  local git_root=$(git_find_root)
  if [[ -n "$git_root" ]]; then
    local git_dirty=$(git_dirty_prompt)
    local need_push=$(need_push_prompt)
    export PROMPT="${PROMPT}${git_dirty}${need_push}"
  fi

  local venv=$(venv_prompt)
  if [[ -n "$venv" ]]; then
    export PROMPT="${venv}${PROMPT}"
  fi

  # add small double caret icon and new line
  export PROMPT="$PROMPT"$'\n'"» "
}

precmd() {
  title "zsh" "%m" "%55<...<%~"
  set_prompt
}

# ruby_version() {
#   if (( $+commands[rbenv] ))
#   then
#     echo "$(rbenv version | awk '{print $1}')"
#   fi
#
#   if (( $+commands[rvm-prompt] ))
#   then
#     echo "$(rvm-prompt | awk '{print $1}')"
#   fi
# }
#
# rb_prompt() {
#   if ! [[ -z "$(ruby_version)" ]]; then
#     local version=$(ruby_version)
#   else
#     version="sys"
#   fi
#
#   echo "%{$fg[white]%}[rb $version]%{$reset_color%} "
# }
#
# node_prompt() {
#   if type node > /dev/null; then
#     local nodev=${$(node -v)/v}
#     local npmv=${$(npm -v)/v}
#     echo "%{$fg[white]%}[node $nodev/$npmv]%{$reset_color%} "
#   fi
# }
