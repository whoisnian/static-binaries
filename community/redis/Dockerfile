# syntax=docker.io/docker/dockerfile:1.14
# https://docs.docker.com/build/dockerfile/frontend/

ARG ALPINE_VERSION=3.21.3
ARG PACKAGE_PATH=community/redis
ARG PACKAGE_NAME=redis
ARG PACKAGE_VERSION=7.2.7

FROM docker.io/library/alpine:${ALPINE_VERSION} AS build

# https://docs.docker.com/build/building/variables/#scoping
ARG BUILDARCH
ARG ALPINE_VERSION
ARG PACKAGE_PATH
ARG PACKAGE_NAME
ARG PACKAGE_VERSION

# depends (4)
#   /bin/sh
#   so:libc.musl-x86_64.so.1
#   so:libcrypto.so.3 => libcrypto.a provided by openssl-libs-static
#   so:libssl.so.3 => libssl.a provided by openssl-libs-static
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$BUILDARCH,sharing=locked \
    ln -s /var/cache/apk /etc/apk/cache && apk upgrade && apk add \
    alpine-sdk openssl-libs-static

WORKDIR /src
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$BUILDARCH,sharing=locked \
    wget -O "${PACKAGE_NAME}.tar.gz" "https://gitlab.alpinelinux.org/alpine/aports/-/archive/v${ALPINE_VERSION}/aports-v${ALPINE_VERSION}.tar.gz?path=${PACKAGE_PATH}" && \
    tar -xf "${PACKAGE_NAME}.tar.gz" --strip-components=1 && \
    cd "${PACKAGE_PATH}" && grep -q "pkgver=${PACKAGE_VERSION}" APKBUILD && echo 'pkgver matched' && \
    export CFLAGS=-static && export LDFLAGS=-static && \
    abuild -F fetch verify unpack prepare mkusers deps build package undeps && \
    "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/redis-cli" --help && \
    strip "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/redis-cli" -o /usr/local/bin/redis-cli

FROM scratch
COPY --from=build /usr/local/bin/redis-cli /
ENTRYPOINT ["/redis-cli"]
