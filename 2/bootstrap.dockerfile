FROM python:2.7.12-alpine
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
        tar \
        tk \
        tk-dev \
        zlib-dev

# Download the source
ENV PYPY_VERSION="5.3.1" \
    PYPY_SHA256="31a52bab584abf3a0f0defd1bf9a29131dab08df43885e7eeddfc7dc9b71836e"
RUN set -x \
    && apk add --no-cache curl \
    && PYPY_FILE="pypy2-v${PYPY_VERSION}-src" \
    && curl -SLO "https://bitbucket.org/pypy/pypy/downloads/$PYPY_FILE.tar.bz2" \
    && echo "$PYPY_SHA256  $PYPY_FILE.tar.bz2" | sha256sum -c - \
    && mkdir -p /usr/src/pypy \
    && tar -xjC /usr/src/pypy --strip-components=1 -f "$PYPY_FILE.tar.bz2" \
    && rm "$PYPY_FILE.tar.bz2" \
    && apk del curl

COPY ./build.sh /build.sh

VOLUME /tmp

WORKDIR /usr/src/pypy
CMD ["/build.sh"]
