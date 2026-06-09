# https://hub.docker.com/layers/library/clojure/temurin-21-tools-deps-alpine/images/sha256-03867e07345101c349fe1e1311de391d73c6b49ee7381f4eb196aede6e58624e
FROM clojure:temurin-21-tools-deps-alpine@sha256:03867e07345101c349fe1e1311de391d73c6b49ee7381f4eb196aede6e58624e

# https://github.com/reviewdog/reviewdog/blob/master/CHANGELOG.md#v0210---2025-09-03
ENV REVIEWDOG_VERSION=v0.21.0

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}

COPY lint.sh /lint.sh

ENTRYPOINT ["bash", "/lint.sh"]
