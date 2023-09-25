assumed="/opt/homebrew/bin"

export PATH="$PATH:$assumed"

# yarn global bin is slow
# async compare actual yarn bin to assumed yarn bin
check() {
  actual=$(yarn global bin)

  if [[ $actual != $assumed ]]; then
    export PATH="$PATH:$actual"

    local color_error="1"
    local color_warn="3"
    local color_dim="7"
    local color_correct="2"

    echo ""
    echo ""
    print -P -- "%F{$color_warn}WARNING: Update assumed yarn global bin.%f"
    echo ""
    print -P -- "%F{$color_error}  assumed%f $assumed"
    print -P -- "%F{$color_correct}  actual%f  $actual"
    print -P -- "%F{$color_dim}  in      $GROK_TOPICS/yarn/path.zsh:1:9%f"
    echo ""
    exit
  fi

  unset assumed
  unset actual
  unset set_actual
  unset -f check
}

check &! # background

