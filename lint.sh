#!/bin/bash
set -o pipefail

cd "${GITHUB_WORKSPACE}" || exit 1

# https://github.com/reviewdog/reviewdog/issues/1158
git config --global --add safe.directory "$GITHUB_WORKSPACE" || exit 1

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

echo "::group::Configuration"
echo "GitHub Tokens are not logged"
echo "INPUT_PATH: ${INPUT_PATH}"
echo "INPUT_EXCLUDE: ${INPUT_EXCLUDE}"
echo "INPUT_PATTERN: ${INPUT_PATTERN}"
echo "INPUT_CLJ_KONDO_CONFIG: ${INPUT_CLJ_KONDO_CONFIG}"
echo "INPUT_CLJ_KONDO_VERSION: ${INPUT_CLJ_KONDO_VERSION}"
echo "INPUT_REPORTER: ${INPUT_REPORTER}"
echo "INPUT_FILTER_MODE: ${INPUT_FILTER_MODE}"
echo "INPUT_FAIL_ON_ERROR: ${INPUT_FAIL_ON_ERROR}"
echo "INPUT_LEVEL: ${INPUT_LEVEL}"
echo "INPUT_REVIEWDOG_FLAGS: ${INPUT_REVIEWDOG_FLAGS}"
echo "::endgroup::"

if [ -n "${INPUT_PATTERN}" ]; then
  name_expr=( -name "${INPUT_PATTERN}" )
else
  name_expr=( \( -name '*.clj' -o -name '*.cljs' -o -name '*.cljc' -o -name '*.cljx' -o -name '*.cljd' -o -name '*.cljr' \) )
fi

# Apply INPUT_EXCLUDE only when set, and always prune .git
# Prevents Git internals from being linted, regardless of branch name.
exclude_expr=()
if [ -n "${INPUT_EXCLUDE}" ]; then
  exclude_expr=( -not -path "${INPUT_EXCLUDE}" )
fi

sources=$(find "${INPUT_PATH}" \
  -name .git -prune -o \
  -type f "${name_expr[@]}" "${exclude_expr[@]}" -print)

echo "::group::Files to lint"
echo "${sources}"
echo "::endgroup::"

# Pass a user --config only when set.
# clj-kondo treats a --config value that does not start with "{" (including the empty string) as a file path.
# This prints a misleading "error while reading <workspace> (No such file or directory)".
config_args=()
if [ -n "${INPUT_CLJ_KONDO_CONFIG}" ]; then
  config_args=( --config "${INPUT_CLJ_KONDO_CONFIG}" )
fi

echo "::group::Execution Logs"
clj -Sdeps "{:deps {clj-kondo/clj-kondo {:mvn/version \"${INPUT_CLJ_KONDO_VERSION}\"}}}" -M -m clj-kondo.main \
  --lint ${sources} \
  "${config_args[@]}" \
  --config '{:output {:pattern "{{filename}}:{{row}}:{{col}}: {{message}}"}}' \
  --config '{:summary false}' \
  --parallel \
  | reviewdog \
      -efm="%f:%l:%c: %m" \
      -name="clj-kondo" \
      -reporter="${INPUT_REPORTER}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" \
      "${INPUT_REVIEWDOG_FLAGS}"

# Capture pipeline statuses immediately.
# Required to run prior to the following echo
kondo_exit_code=${PIPESTATUS[0]} reviewdog_exit_code=${PIPESTATUS[1]}

echo "::endgroup::"

echo "clj-kondo finished with exit code: ${kondo_exit_code}"
echo "reviewdog finished with exit code: ${reviewdog_exit_code}"

# clj-kondo exit codes:
#
#   0 = no findings
#   1 = internal error
#   2 = warnings surfaced by the linter
#   3 = errors surfaced by the linter
if [ "${kondo_exit_code}" -ne 0 ]; then
  echo "::error::clj-kondo exited ${kondo_exit_code} (0=clean, 1=internal, 2=warnings, 3=errors)."
fi

# An internal clj-kondo error (exit 1) must fail the execution.
# ::error:: annotations do not fail a step on their own.
if [ "${kondo_exit_code}" -eq 1 ]; then
  exit 1
fi

exit $reviewdog_exit_code
