#!/usr/bin/env bash

CURRENT_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
source "$CURRENT_DIR/shared.sh"

TDD_STATUS_DIRS=$(get_tmux_option "@tdd_status_dirs" "")
PANE_DIR="$(tmux display-message -p -F "#{pane_current_path}" -t0)"

print_status() {
  color_fail="#[bg=red] #[fg=black]"
  color_pass="#[bg=green] #[fg=black]"
  color_none="#[bg=colour8] #[fg=gray]"
  check_directory=1
  check_cmd=""

  # -- perform a linear scan over the directory list
  # -- where each item is a pair (dir, cmd), where dir is the directory itself
  # -- and cmd is the unit test command like `npm run test` that should be executed in dir
  # -- [1]: the current pane's dir is in the list, so we'll run cmd in dir and show the pass/fail status
  # -- [2]: IFS = "Internal Field Separator", the Bash way to scan over a comma separated list
  OIFS=$IFS
  IFS=','
  for pair in $TDD_STATUS_DIRS; do
    dir=$(echo $pair | cut -d : -f1)
    cmd=$(echo $pair | cut -d : -f2)
    if [ $dir == $PANE_DIR ]; then # [1]
      check_directory=0
      check_cmd=$cmd
    fi
  done
  IFS=$OIFS

  if [ $check_directory -eq 0 ]; then # [1]
    exit_code=$(cd "$PANE_DIR" && $check_cmd > /dev/null 2>&1 && echo $?)
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
