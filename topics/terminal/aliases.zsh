color-test() {
  names=(black red green yellow blue magenta cyan white)

  printf "\n\033[1m%-18s %-18s %-18s %-18s\033[0m\n" "Normal FG" "Bright FG" "Normal BG" "Bright BG"
  for i in $(seq 0 7); do
    FG=$((30 + i))
    BG=$((40 + i))
    FG_BRIGHT=$((90 + i))
    BG_BRIGHT=$((100 + i))
    name="${names[$i + 1]}"
    printf "\033[${FG}m%-18s\033[0m " "$name"
    printf "\033[${FG_BRIGHT}m%-18s\033[0m " "bright-$name"
    if [ $i -eq 7 ]; then
      printf "\033[30;${BG}m%-18s\033[0m " "$name"
    else
      printf "\033[${BG}m%-18s\033[0m " "$name"
    fi
    printf "\033[30;${BG_BRIGHT}m%-18s\033[0m\n" "bright-$name"
  done

  echo
}