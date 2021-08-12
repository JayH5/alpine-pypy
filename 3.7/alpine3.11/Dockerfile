FROM jamiehewland/alpine-pypy-build:2.7-7.3.1-alpine3.11

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
        patch \
        python2-dev \
        readline-dev \
        sqlite-dev \
        tar \
        tk \
        tk-dev \
        xz-dev \
        zlib-dev


# Download the source
ENV PYPY_VERSION 7.3.5
ENV PYPY_SHA256SUM d920fe409a9ecad9d074aa8568ca5f3ed3581be66f66e5d8988b7ec66e6d99a2
RUN pip install --no-cache-dir pycparser
RUN set -ex \
    && wget -O pypy.tar.bz2 "https://downloads.python.org/pypy/pypy3.7-v${PYPY_VERSION}-src.tar.bz2" \
    && echo "$PYPY_SHA256SUM *pypy.tar.bz2" | sha256sum -c - \
    && mkdir -p /usr/src/pypy \
    && tar -xjC /usr/src/pypy --strip-components=1 -f pypy.tar.bz2 \
    && rm pypy.tar.bz2

WORKDIR /usr/src/pypy

# For some reason. Non bootstrap image can't patch
# Run patches
# COPY patches /patches
# RUN set -ex; \
#     for patch in /patches/*.patch; do \
#         patch -p1 -E -i "$patch"; \
#     done \
#     && rm -rf /patches

COPY build.sh /build.sh
CMD ["/build.sh"]

VOLUME /tmp
