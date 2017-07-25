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

You'll need to add two pieces of config to your *.tmux.conf* file to:
1. **Configure Directories**: provide the plugin with all your project directories and corresponding unit test commands
    ```
    set -g @tdd_status_dirs "\
    /Users/JoeBloggs/some/directory:npm run unit,\
    /Users/JoeBloggs/another/directory:rake test,\
    /Users/JoeBloggs/yet/another/directory:grunt unit"
    ```
    The `@tdd_status_dirs` option holds a comma seperated list of *dir*:*cmd* pairs, where 
    where *dir* is the directory itself and *cmd* is the unit test command 
    like `npm run test` that should be executed in *dir*
2. **Configure Status Bar**: configure either *status-left* or *status-right* to add the string interpolation `#{tdd_status}`
    ```bash
    set -g status-right "#{tdd_status} | %a %h-%d %H:%M "
    ```
    The `#{tdd_status}` interpolation will be read and converted to "Unit Tests: PASSING" or "Unit Tests: FAILING" accordingly
    only when the current directory is in the *\@tdd_status_dirs* list. Otherwise, "Unit Tests: N/A" is shown.

> :warning: You'll need to put both of these two bits of config *before* you import the plugin via `@plugin`!



## License

MIT
