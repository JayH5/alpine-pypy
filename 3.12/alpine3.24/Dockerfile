# syntax=docker/dockerfile:1
FROM alpine:3.24.4 AS base
LABEL maintainer "Jamie Hewland <jhewland@gmail.com>"

# Add build dependencies
RUN echo "@testing https://dl-cdn.alpinelinux.org/alpine/edge/testing" >>/etc/apk/repositories \
 && apk update \
 && apk add --virtual .build-deps \
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
        patch \
        pax-utils \
        readline-dev \
        sqlite-dev \
        tar \
        tk \
        tk-dev \
        xz-dev \
        zlib-dev \
  && apk add pypy@testing \
  && rm -rf /var/cache/apk/*

# Environment variables for downloader and builder
ENV PYPY_VERSION 8.0.1
ENV PYPY_PYTHON 3.12

# Download the source
FROM base AS source
ENV PYPY_SHA256SUM 9d5c82d39d590dc04677f4721738b21d670570cdc9824c003836bafd38556cda
COPY pypy.patch /pypy.patch
COPY source.sh /source.sh
RUN chmod +x /source.sh && /source.sh

# Setup the build environment
FROM base AS build
COPY --from=source /usr/src/pypy /usr/src/pypy
WORKDIR /usr/src/pypy
COPY build.sh /build.sh
RUN chmod +x /build.sh
CMD ["/build.sh"]
VOLUME /tmp
