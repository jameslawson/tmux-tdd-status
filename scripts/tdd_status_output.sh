#!/usr/bin/env bash

CURRENT_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
source "$CURRENT_DIR/shared.sh"


TDD_STATUS_DIRS=$(get_tmux_option "@tdd_status_dirs" "")
PANE_DIR="$(tmux display-message -p -F "#{pane_current_path}" -t0)"

check_directory() {
  # check if $PANE_DIR is inside $TDD_STATUS_DIRS
  # which is comma-separated list of dirs
  # https://stackoverflow.com/a/29301172/3649209
  if [[ ",$TDD_STATUS_DIRS," = *",$PANE_DIR,"* ]]; then
    return 0
  else
    return 1
  fi
}

print_status() {
  color_fail="#[bg=red] #[fg=black]"
  color_pass="#[bg=green] #[fg=black]"
  color_none="#[bg=colour8] #[fg=gray]"

  if check_directory; then
    exit_code=$(cd "$PANE_DIR" && npm run unit > /dev/null 2>&1 && echo $?)
    if [ $exit_code -eq 0 ]; then
      printf "Unit Tests: ${color_pass}PASSING"
    else
      printf "Unit Tests: ${color_fail}FAILING"
    fi
  else
    printf "Unit Tests: ${color_none}  N/A  "
  fi
}

main() {
  print_status
}
main
