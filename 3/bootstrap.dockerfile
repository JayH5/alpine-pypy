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
        tk \
        tk-dev \
        xz-dev \
        zlib-dev

# Download the source
ENV PYPY_VERSION="5.2.0-alpha1" \
    PYPY_SHA256="344c2f088c82ea1274964bb0505ab80d3f9e538cc03f91aa109325ddbaa61426"
RUN set -x \
    && apk add --no-cache curl \
    && PYPY_FILE="pypy3.3-v${PYPY_VERSION}-src" \
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
