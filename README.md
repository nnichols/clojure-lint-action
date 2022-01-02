# Clojure Lint Action

A simple GitHub Action to lint clojure files with [clj-kondo](https://github.com/clj-kondo/clj-kondo) and [reviewdog](https://github.com/reviewdog/reviewdog) on pull requests to improve the code review experience.

## Inputs

### `github_token`

Optional.
`${{ github.token }}` is used by default.

### `level`

Optional.
Report level for reviewdog- must be one of `[info, warning, error]`.
It's same as `-level` flag of reviewdog.

### `reporter`

Reporter of reviewdog command.
Must be one of `[github-pr-check, github-pr-review, github-check]`.
Default is github-pr-check.
github-pr-review can use Markdown and add a link to rule page in reviewdog reports.

### `filter_mode`

Optional.
Filtering mode for the reviewdog command.
Must be one of `[added, diff_context, file, nofilter]`.
Default is added.

### `fail_on_error`

Optional.
Sets and exceptional exit code for reviewdog when errors are found.
Must be one of `[true, false]`.
Default is `false`.

### `reviewdog_flags`

Optional.
Additional reviewdog flags.

### `path`

Optional.
Base directory to run clj-kondo.
Same as `[path]` of `find` command.
Default: `.`

### `pattern`

Optional.
File patterns of target files.
Same as `-name [pattern]` of `find` command.
Default: `*.clj,*.cljc,*.cljs,*.cljx`

### `exclude`

Optional.
Exclude patterns of target files.
Same as `-not -path [exclude]` of `find` command.
e.g. `./git/*`

### `clj_kondo_config`

Optional.
Flags to pass to clj-kondo's `--config` option, which may either be in-line options or a path to a config file.
Default: `'{:output {:pattern "{{filename}}:{{row}}:{{col}}: {{message}}"}}'`

## Example usage

### [.github/workflows/reviewdog.yml](.github/workflows/reviewdog.yml)

```yml
name: Lint Clojure
on: [pull_request]
jobs:
  clj-kondo:
    name: runner / clj-kondo
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v1
      - name: clj-kondo
        uses: nnichols/clojure-lint-action@v1
        with:
          github_token: ${{ secrets.github_token }}
          reporter: github-pr-review # Change reporter.
```

## Licensing

Copyright © 2021-2022 [Nick Nichols](https://nnichols.github.io/)

Distributed under the [MIT License](https://github.com/nnichols/clojure-vulnerability-check-action/blob/master/LICENSE)
