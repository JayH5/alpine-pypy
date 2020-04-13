FROM python:2.7-alpine3.11
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
        zlib-dev

RUN pip install --no-cache-dir pycparser

# Download the source
ENV PYPY_VERSION 7.3.1
ENV PYPY_SHA256SUM fa3771514c8a354969be9bd3b26d65a489c30e28f91d350e4ad2f4081a9c9321

RUN set -ex; \
    wget -O pypy.tar.bz2 "https://bitbucket.org/pypy/pypy/downloads/pypy2.7-v${PYPY_VERSION}-src.tar.bz2"; \
    echo "$PYPY_SHA256SUM *pypy.tar.bz2" | sha256sum -c -; \
    mkdir -p /usr/src/pypy; \
    tar -xjC /usr/src/pypy --strip-components=1 -f pypy.tar.bz2; \
    rm pypy.tar.bz2

WORKDIR /usr/src/pypy

COPY ./build.sh /build.sh
CMD ["/build.sh"]

VOLUME /tmp
