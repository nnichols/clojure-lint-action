#!/bin/bash

cd "${GITHUB_WORKSPACE}" || exit

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

clj-kondo --lint $(find "${INPUT_PATH}" -not -path "${INPUT_EXCLUDE}" -type f -name "${INPUT_PATTERN}") \
  --config "${INPUT_CLJ_KONDO_CONFIG:-'{:output {:pattern "{{filename}}:{{row}}:{{col}}: {{message}}"}}'}" \
  --config '{:output {:pattern "{{filename}}:{{row}}:{{col}}: {{message}}"}}' \
  | reviewdog \
      -efm="%f:%l:%c: %m" \
      -name="clj-kondo" \
      -reporter="${INPUT_REPORTER}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" \
      ${INPUT_REVIEWDOG_FLAGS}
