FROM clojure:temurin-18-tools-deps-alpine

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
