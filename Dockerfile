# https://hub.docker.com/layers/library/clojure/temurin-18-tools-deps-alpine/images/sha256-11322c60157b98e87bd55d523854d177e4b150f7b0ca2179550d7cd2a60961f8
FROM clojure:temurin-18-tools-deps-alpine@sha256:3c4b747a4cf5681cf2b398cd3d38778f143acec6c937627ecb05ef09252db4e3

ENV REVIEWDOG_VERSION=v0.12.0

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}

RUN apk --no-cache add gcc ncurses-dev libc-dev readline-dev make \
    && cd /tmp \
    && wget https://github.com/hanslub42/rlwrap/releases/download/v0.43/rlwrap-0.43.tar.gz \
    && tar -xzvf rlwrap-0.43.tar.gz \
    && cd rlwrap-0.43 \
    && ./configure \
    && make install \
    && rm -rf rlwrap-0.43 \
    && apk del gcc ncurses-dev libc-dev readline-dev make

COPY lint.sh /lint.sh

ENTRYPOINT ["bash", "/lint.sh"]
