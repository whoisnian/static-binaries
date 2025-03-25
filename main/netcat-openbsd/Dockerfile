# syntax=docker.io/docker/dockerfile:1.14
# https://docs.docker.com/build/dockerfile/frontend/

ARG ALPINE_VERSION=3.21.3
ARG PACKAGE_PATH=main/netcat-openbsd
ARG PACKAGE_NAME=netcat-openbsd
ARG PACKAGE_VERSION=1.226-1.1

FROM docker.io/library/alpine:${ALPINE_VERSION} AS build

# https://docs.docker.com/build/building/variables/#scoping
ARG BUILDARCH
ARG ALPINE_VERSION
ARG PACKAGE_PATH
ARG PACKAGE_NAME
ARG PACKAGE_VERSION

# depends (2)
#   so:libbsd.so.0 => libbsd.a provided by libbsd-static
#   so:libc.musl-x86_64.so.1
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$BUILDARCH,sharing=locked \
    ln -s /var/cache/apk /etc/apk/cache && apk upgrade && apk add \
    alpine-sdk libbsd-static

WORKDIR /src
RUN wget -O "${PACKAGE_NAME}.tar.gz" "https://gitlab.alpinelinux.org/alpine/aports/-/archive/v${ALPINE_VERSION}/aports-v${ALPINE_VERSION}.tar.gz?path=${PACKAGE_PATH}" && \
    tar -xf "${PACKAGE_NAME}.tar.gz" --strip-components=1 && \
    cd "${PACKAGE_PATH}" && grep -q "pkgver=${PACKAGE_VERSION}" APKBUILD && echo 'pkgver matched' && \
    export CFLAGS=-static && \
    abuild -F fetch verify unpack prepare deps build package undeps && \
    "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/nc" -h && \
    strip "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/nc" -o /usr/local/bin/nc

FROM scratch
COPY --from=build /usr/local/bin/nc /
ENTRYPOINT ["/nc"]
