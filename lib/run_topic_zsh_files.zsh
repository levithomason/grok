###############################################################################
# RUN TOPIC ZSH FILES
#
# In this order:
#
# 1) path.zsh
# 2) *.zsh

echo 'GROK: run_topic_zsh_files'
run_file() {
  local file="$1"
  local start_time end_time elapsed_time

  # Capture the start time
  start_time=$SECONDS

  # Source the file
  source "$file"

  # Capture the end time and calculate elapsed time
  end_time=$SECONDS
  elapsed_time=$((end_time - start_time))

  # Print the filename relative to $GROK_ROOT
  local rel_file="${file/${GROK_ROOT}\/topics\//}"

  # set color based on time
  if [[ $elapsed_time -gt 1 ]]; then
    color="\e[31m" # red
  elif [[ $elapsed_time -eq 1 ]]; then
    color="\e[33m" # yellow
  else
    color="\e[2m" # dim
  fi

  # Print the time taken to run the file and the file name
  echo -e "${color}${elapsed_time}s ${rel_file}\e[0m"
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

# Cleanup
unset config_files
