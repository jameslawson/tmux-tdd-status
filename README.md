<h1 align="center">tmux-tdd-status</h1>
<p align="center">
  :white_check_mark: A tmux plugin that displays PASS/FAIL results for unit tests :negative_squared_cross_mark:	  <br>
</p>

![battery charging](/docs/screenshot.png)

## Installation

Via [tmux-plugin-manager](https://github.com/tmux-plugins/tpm) (recommended):
```
set -g @plugin 'jameslawson/tmux-tdd-status'
```

## Usage

You'll need to add config to your *.tmux.conf* file:

> :warning: You'll need put this config *before* the line that imports the plugin via `@plugin`!


1. **Configure Directories**: declare your project directories with the corresponding unit test commands:
    ```
    set -g @tdd_status_dirs "\
    /Users/JoeBloggs/some/directory:npm run unit,\
    /Users/JoeBloggs/another/directory:rake test,\
    /Users/JoeBloggs/yet/another/directory:grunt unit"
    ```
    The *\@tdd_status_dirs* option holds a comma seperated list of *dir*:*cmd* pairs, 
    where *dir* is the project directory and *cmd* is the unit test command that should be executed in *dir*
2. **Configure Status Bar**: configure either *status-left* or *status-right* and add the string interpolation *#{tdd_status}*:
    ```bash
    set -g status-right "#{tdd_status} | %a %h-%d %H:%M "
    ```
    The *#{tdd_status}* interpolation will be read and converted to "Unit Tests: PASSING" or "Unit Tests: FAILING" accordingly
    only when the current directory is in the *\@tdd_status_dirs* list. Otherwise, "Unit Tests: N/A" is shown.


## Config

- `@tdd_status_dirs` (*required*) - A comma seperated list of *dir*:*cmd* pairs
- `@tdd_status_color_fail` (*optional*) - Color of the status when tests are passing. 
- `@tdd_status_color_pass` (*optional*) - Color of the status when tests are failing. 
- `@tdd_status_color_none` (*optional*) - Color of the status when no tests are found. 

## License

MIT
