# Changelog

## v9 - 2026-06-02

- Asserts Release Immutability in GitHub.
  To learn more, please read GitHub's announcement here: <https://github.blog/changelog/2025-08-26-releases-now-support-immutability-in-public-preview/>
  Released assets and the release itself are now immutable and can be verified using:

```bash
gh release verify <tag>
gh release verify-asset <tag> <asset>
```

## v8 - 2026-06-02

- Bumps Temurin image to v21 as a base
- Remove in-image dependency pins
- Bumps Reviewdog base version to 21
- Documents passing in-line clj-kondo config to the action
- Emits better logs to differentiate clj-kondo and reviewdog failures

## v7 - 2026-05-21

- Allows overriding the running version of clj-kondo with `clj_kondo_version`.

## v6 - 2025-08-16

- Enable parallel clj-kondo execution
- Log the safe inputs from the workflow

## v5 - 2025-08-14

- Update clojure:temurin-18-tools-deps-alpine Docker digest to 3c4b747

## v4 - 2024-12-27

- Update clojure:temurin-18-tools-deps-alpine Docker digest to 2397fa7

## v3 - 2024-12-03

- Pin the Alpine image version

## v2 - 2022-07-06

- Migrate to Alpine tools.deps image
- Add an output group for files that will be linted

## v1 - 2021-07-07

- Initial Implementation
