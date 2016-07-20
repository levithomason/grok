autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

git_branch() {
  echo $($git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
  if $(! $git status -s &> /dev/null)
  then
    echo ""
  else
    if [[ $($git status --porcelain) == "" ]]
    then
      echo "on %{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}"
    else
      echo "on %{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%}"
    fi
  fi
}

git_prompt_info () {
 ref=$($git symbolic-ref HEAD 2>/dev/null) || return
# echo "(%{\e[0;33m%}${ref#refs/heads/}%{\e[0m%})"
 echo "${ref#refs/heads/}"
}

unpushed () {
  $git cherry -v @{upstream} 2>/dev/null
}

need_push () {
  if [[ $(unpushed) == "" ]]
  then
    echo " "
  else
    echo " with %{$fg_bold[magenta]%}unpushed%{$reset_color%} "
  fi
}

ruby_version() {
  if (( $+commands[rbenv] ))
  then
    echo "$(rbenv version | awk '{print $1}')"
  fi

  if (( $+commands[rvm-prompt] ))
  then
    echo "$(rvm-prompt | awk '{print $1}')"
  fi
}

rb_prompt() {
  if ! [[ -z "$(ruby_version)" ]]; then
    local version=$(ruby_version)
  else
    version="sys"
  fi

  echo "%{$fg[white]%}[rb $version]%{$reset_color%} "
}

directory_name() {
  echo "%{$fg_bold[cyan]%}%1/%\/%{$reset_color%}"
}

venv_prompt() {
  if ! [[ -z ${VIRTUAL_ENV} ]]; then
    local env=$(basename $VIRTUAL_ENV)
  else
    local env="sys"
  fi

  echo "%{$fg[white]%}[py $env]%{$reset_color%} "
}

node_prompt() {
  if type node > /dev/null; then
    local nodev=${$(node -v)/v}
    local npmv=${$(npm -v)/v}
    echo "%{$fg[white]%}[node $nodev/$npmv]%{$reset_color%} "
  fi
}

set_prompt () {
  export PROMPT=$'\nin $(directory_name) $(git_dirty)$(need_push)\n› '

  # getting versions is terribly slow
  # export RPROMPT="$(node_prompt)$(rb_prompt)$(venv_prompt)"
}

precmd() {
  title "zsh" "%m" "%55<...<%~"
  set_prompt
}
