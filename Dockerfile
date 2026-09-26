# https://hub.docker.com/layers/library/clojure/temurin-21-tools-deps-alpine/images/sha256-03867e07345101c349fe1e1311de391d73c6b49ee7381f4eb196aede6e58624e
FROM clojure:temurin-21-tools-deps-alpine@sha256:fe76e91748c6092df2f4c3fcb712525b992ec83bfa81d2569ac509a59a9499da

# https://github.com/reviewdog/reviewdog/blob/master/CHANGELOG.md#v0210---2025-09-03
ENV REVIEWDOG_VERSION=v0.21.0

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}

COPY lint.sh /lint.sh

ENTRYPOINT ["bash", "/lint.sh"]
