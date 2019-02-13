FROM jamiehewland/alpine-pypy:2.7-7.0.0-alpine3.9
LABEL maintainer "Jamie Hewland <jhewland@gmail.com>"

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
        xz-dev \
        zlib-dev

# Download the source
ENV PYPY_VERSION 7.0.0
ENV PYPY_SHA256SUM b2ddb0f45cb4e0384fb498ef7fcca2ac96c730b9000affcf8d730169397f017f

RUN set -ex; \
    wget -O pypy.tar.bz2 "https://bitbucket.org/pypy/pypy/downloads/pypy3.5-v${PYPY_VERSION}-src.tar.bz2"; \
    echo "$PYPY_SHA256SUM *pypy.tar.bz2" | sha256sum -c -; \
    mkdir -p /usr/src/pypy; \
    tar -xjC /usr/src/pypy --strip-components=1 -f pypy.tar.bz2; \
    rm pypy.tar.bz2

WORKDIR /usr/src/pypy

COPY patches /patches
RUN set -ex; \
    for patch in /patches/*.patch; do \
        patch -p1 -E -i "$patch"; \
    done

COPY build.sh /build.sh
CMD ["/build.sh"]

VOLUME /tmp
