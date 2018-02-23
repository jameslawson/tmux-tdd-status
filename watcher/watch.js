const VALID_DIRS = {
  '/Users/lawsoj03/playground/tdd': 'npm run test'
};

// -------------------------------------

const path = require('path');
const Promise = require('bluebird');
const { writeFileAsync } = Promise.promisifyAll(require('fs'));
const { exec, spawn } = require('child-process-promise');

const Rx = require('rxjs/Rx');
require('rxjs/add/observable/combineLatest');
const { Observable } = require('rxjs/Observable');
const { interval, fromPromise, combineLatest } = Observable;
const { resolve, all } = Promise

const TMUX_DIR_POLL_INTERVAL = 200;
const TMUX_DIR_CMD = 'tmux display-message -p -F "#{pane_current_path}"';
const HOME_DIR = require('os').homedir();
const FILEPATH_EXIT_CODE = path.join(HOME_DIR, '.tdd.code.txt');
const FILEPATH_STDOUT = path.join(HOME_DIR, '.tdd.output.txt');

const tmuxDir$ = interval(TMUX_DIR_POLL_INTERVAL)
  .switchMap(x => fromPromise(exec(TMUX_DIR_CMD)))
  .map(dir => dir.stdout.trim())
  .distinctUntilChanged();

// every time we enter a tdd directory, run tests and write results
const write$ = tmuxDir$
  .filter(dir => VALID_DIRS[dir] !== undefined)
  .switchMap(dir => {
    return fromPromise(exec(VALID_DIRS[dir])
      .then(proc => resolve([ proc.childProcess.exitCode, proc.stdout]))
      .catch(err => resolve([err.code, err.stdout])))
  })
  .switchMap(([code, stdout]) => {
    const codeWrite = writeFileAsync(FILEPATH_EXIT_CODE, code, {});
    const stdoutWrite = writeFileAsync(FILEPATH_STDOUT, stdout, {});
    return fromPromise(all([codeWrite, stdoutWrite]));
  });

// every time we leave a tdd directory, run tests and write results
const clear$ = tmuxDir$
  .filter(dir => VALID_DIRS[dir] == undefined)
  .switchMap(__ => writeFileAsync(FILEPATH_EXIT_CODE, 'NA', {}));

write$.subscribe(__ => { console.log('results written for tdd directory'); });
clear$.subscribe(__ => { console.log('clearing results'); });
console.log('watching the /tests directory for changes...')
