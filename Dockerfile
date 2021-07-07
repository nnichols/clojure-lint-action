FROM nnichols/clojure-lint-action

ENV REVIEWDOG_VERSION=v0.12.0

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}
RUN apk --update add jq git findutils && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*

COPY lint.sh /lint.sh

ENTRYPOINT ["bash", "/lint.sh"]
