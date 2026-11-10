# https://hub.docker.com/layers/library/clojure/temurin-21-tools-deps-alpine/images/sha256-03867e07345101c349fe1e1311de391d73c6b49ee7381f4eb196aede6e58624e
FROM clojure:temurin-21-tools-deps-alpine@sha256:46fc127b7b4f64e5d6eaddb663e394d81368ca1a3b4270790b8c3cde8f529f1c

# https://github.com/reviewdog/reviewdog/blob/master/CHANGELOG.md#v0210---2025-09-03
ENV REVIEWDOG_VERSION=v0.21.0

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}

COPY lint.sh /lint.sh

ENTRYPOINT ["bash", "/lint.sh"]
