FROM jamiehewland/alpine-pypy:5.1.1
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
ENV PYPY_VERSION="5.1.1" \
    PYPY_SHA256="ca3d943d7fbd78bb957ee9e5833ada4bb8506ac99a41b7628790e286a65ed2be"
RUN set -x \
    && apk add --no-cache curl \
    && PYPY_FILE="pypy-${PYPY_VERSION}-src" \
    && curl -SLO "https://bitbucket.org/pypy/pypy/downloads/$PYPY_FILE.tar.bz2" \
    && echo "$PYPY_SHA256  $PYPY_FILE.tar.bz2" | sha256sum -c - \
    && mkdir -p /usr/src \
    && tar -xjC /usr/src -f "$PYPY_FILE.tar.bz2" \
    && mv "/usr/src/$PYPY_FILE" /usr/src/pypy \
    && rm "$PYPY_FILE.tar.bz2" \
    && apk del curl

RUN ln -s /usr/local/bin/pypy /usr/local/bin/python

COPY ./build.sh /build.sh

VOLUME /tmp

WORKDIR /usr/src/pypy
CMD ["/build.sh"]
