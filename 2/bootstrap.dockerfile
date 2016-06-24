FROM python:2.7.11-alpine
MAINTAINER Jamie Hewland <jhewland@gmail.com>

# Add build dependencies
RUN apk add --no-cache --virtual .build-deps \
        bzip2-dev \
        expat-dev \
        gcc \
        gdbm-dev \
        libc-dev \
        libffi-dev \
        linux-headers \
        make \
        ncurses-dev \
        openssl-dev \
        pax-utils \
        readline-dev \
        sqlite-dev \
        tk \
        tk-dev \
        zlib-dev

# Download the source
ENV PYPY_VERSION="5.3.0" \
    PYPY_SHA256="4142eb8f403810bc88a4911792bb5a502e152df95806e33e69050c828cd160d5"
RUN set -x \
    && apk add --no-cache curl \
    && PYPY_FILE="pypy2-v${PYPY_VERSION}-src" \
    && curl -SLO "https://bitbucket.org/pypy/pypy/downloads/$PYPY_FILE.tar.bz2" \
    && echo "$PYPY_SHA256  $PYPY_FILE.tar.bz2" | sha256sum -c - \
    && mkdir -p /usr/src \
    && tar -xjC /usr/src -f "$PYPY_FILE.tar.bz2" \
    && mv "/usr/src/$PYPY_FILE" /usr/src/pypy \
    && rm "$PYPY_FILE.tar.bz2" \
    && apk del curl

COPY ./build.sh /build.sh

VOLUME /tmp

WORKDIR /usr/src/pypy
CMD ["/build.sh"]
