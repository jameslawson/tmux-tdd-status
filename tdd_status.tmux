#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

tdd_status_output="#($CURRENT_DIR/scripts/tdd_status_output.sh)"
tdd_status_interpolation_string="\#{online_status}"

source $CURRENT_DIR/scripts/shared.sh

do_interpolation() {
  local string="$1"
  local interpolated="${string/$tdd_status_interpolation_string/$tdd_status_output}"
  echo "$interpolated"
}

update_tmux_option() {
  local option="$1"
  local option_value="$(get_tmux_option "$option")"
  local new_option_value="$(do_interpolation "$option_value")"
  set_tmux_option "$option" "$new_option_value"
}

main() {
  update_tmux_option "status-right"
  update_tmux_option "status-left"
}

main
