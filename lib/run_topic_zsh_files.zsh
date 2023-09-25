###############################################################################
# RUN TOPIC ZSH FILES
#
# In this order:
#
# 1) path.zsh
# 2) *.zsh

# Homebrew has shellenv we need since we use gdate in this file
source $GROK_TOPICS/homebrew/path.zsh

[[ -n $GROK_DEBUG ]] && echo 'GROK: run_topic_zsh_files'

# array of slow files to print at the end
typeset -a slow_files

run_file() {
  local file="$1"
  local start_time end_time elapsed_time

  # Calculate execution time
  start_time=$(gdate +%s%3N)
  source "$file"
  end_time=$(gdate +%s%3N)
  elapsed_time=$((end_time - start_time))

  # Print the filename relative to $GROK_ROOT
  local rel_file="${file/${GROK_ROOT}\/topics\//}"

  print_file() {
    local padded_time=$(printf "%7s" "${elapsed_time}ms")
    # Print the time taken to run the file and the file name
    print -n -P -- "%F{$color}${padded_time} ${rel_file}%f"
  }

  print_dot() {
    # write a dot with no new line
    print -n -P -- "%F{$color}.%f"
  }

  # set color based on time
  if [[ $elapsed_time -gt 500 ]]; then
    color="1" # red
    print_dot
    slow_files+=("$(print_file)")
  elif [[ $elapsed_time -gt 250 ]]; then
    color="3" # yellow
    slow_files+=("$(print_file)")
    print_dot
  elif [[ $elapsed_time -gt 100 ]]; then
    color="7" # somewhat dim
    slow_files+=("$(print_file)")
    print_dot
  else
    color="8" # very dim
    print_dot
  fi
}

# Unique array of all `*.zsh` files
typeset -U config_files
config_files=($GROK_TOPICS/**/*.zsh)

# path.zsh
for file in ${(M)config_files:#*/path.zsh}; do
  run_file "$file"
done

# *.zsh (except path)
for file in ${config_files:#*/path.zsh}; do
  run_file "$file"
done

echo '' # newline for ending the dots

# Print slow files
if [[ -n $slow_files ]]; then
  for file in $slow_files; do
    echo "  $file"
  done
  echo ''
fi

# Cleanup
unset config_files
unset slow_files