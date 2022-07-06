#!/bin/bash

cd "${GITHUB_WORKSPACE}" || exit
git config --global --add safe.directory "$GITHUB_WORKSPACE" || exit 1

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

sources=$(find "${INPUT_PATH}" -not -path "${INPUT_EXCLUDE}" -type f -name "${INPUT_PATTERN}")

echo "::group::Files to lint"
echo "${sources}"
echo "::endgroup::"

clj -Sdeps '{:deps {clj-kondo/clj-kondo {:mvn/version "RELEASE"}}}' -M -m clj-kondo.main \
  --lint $source \
  --config "${INPUT_CLJ_KONDO_CONFIG}" \
  --config '{:output {:pattern "{{filename}}:{{row}}:{{col}}: {{message}}"}}' \
  | reviewdog \
      -efm="%f:%l:%c: %m" \
      -name="clj-kondo" \
      -reporter="${INPUT_REPORTER}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" \
      "${INPUT_REVIEWDOG_FLAGS}"
