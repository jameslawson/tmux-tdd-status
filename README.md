<h1 align="center">tmux-tdd-status</h1>
<p align="center">
  :white_check_mark: A tmux plugin that displays PASS/FAIL results for unit tests :negative_squared_cross_mark:	  <br>
</p>

## Installation

Via [tmux-plugin-manager](https://github.com/tmux-plugins/tpm) (recommended):
```
set -g @plugin 'jameslawson/tmux-tdd-status'
```

## Usage

```
set -g @tdd_status_dirs "\
/Users/JoeBloggs/A/B/C/D/E/F,\
/Users/JoeBloggs/U/V/W/X/Y/Z"

set -g status-right "#{tdd_status} | %a %h-%d %H:%M "
```

The plugin requires you to configure the either *status-left* or *status-right* and add the string
interpolation `#{tdd_status}`. The plugin will process this
interpolation and convert it to "Unit Tests: PASS" or "Unit Tests: FAIL" accordingly.

## License

MIT
