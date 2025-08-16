#!/bin/bash

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
echo "INPUT_REPORTER: ${INPUT_REPORTER}"
echo "INPUT_FILTER_MODE: ${INPUT_FILTER_MODE}"
echo "INPUT_FAIL_ON_ERROR: ${INPUT_FAIL_ON_ERROR}"
echo "INPUT_LEVEL: ${INPUT_LEVEL}"
echo "INPUT_REVIEWDOG_FLAGS: ${INPUT_REVIEWDOG_FLAGS}"
echo "::endgroup::"

sources=$(find "${INPUT_PATH}" -not -path "${INPUT_EXCLUDE}" -type f -name "${INPUT_PATTERN}")

echo "::group::Files to lint"
echo "${sources}"
echo "::endgroup::"

clj -Sdeps '{:deps {clj-kondo/clj-kondo {:mvn/version "RELEASE"}}}' -M -m clj-kondo.main \
  --lint ${sources} \
  --config "${INPUT_CLJ_KONDO_CONFIG}" \
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

exit_code=$?
echo "clj-kondo finished with exit code: ${exit_code}"

exit $exit_code
