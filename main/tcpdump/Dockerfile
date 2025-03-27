# syntax=docker.io/docker/dockerfile:1.14
# https://docs.docker.com/build/dockerfile/frontend/

ARG ALPINE_VERSION=3.21.3
ARG PACKAGE_PATH=main/tcpdump
ARG PACKAGE_NAME=tcpdump
ARG PACKAGE_VERSION=4.99.5

FROM docker.io/library/alpine:${ALPINE_VERSION} AS build

# https://docs.docker.com/build/building/variables/#scoping
ARG BUILDARCH
ARG ALPINE_VERSION
ARG PACKAGE_PATH
ARG PACKAGE_NAME
ARG PACKAGE_VERSION

# depends (3)
#   so:libc.musl-x86_64.so.1
#   so:libcrypto.so.3 => libcrypto.a provided by openssl-libs-static
#   so:libpcap.so.1 => libpcap.a provided by libpcap-dev
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$BUILDARCH,sharing=locked \
    ln -s /var/cache/apk /etc/apk/cache && apk upgrade && apk add \
    alpine-sdk openssl-libs-static

WORKDIR /src
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$BUILDARCH,sharing=locked \
    wget -O "${PACKAGE_NAME}.tar.gz" "https://gitlab.alpinelinux.org/alpine/aports/-/archive/v${ALPINE_VERSION}/aports-v${ALPINE_VERSION}.tar.gz?path=${PACKAGE_PATH}" && \
    tar -xf "${PACKAGE_NAME}.tar.gz" --strip-components=1 && \
    cd "${PACKAGE_PATH}" && grep -q "pkgver=${PACKAGE_VERSION}" APKBUILD && echo 'pkgver matched' && \
    export CFLAGS=-static && \
    sed -i APKBUILD -e '/^build()/i prepare() {\n\tdefault_prepare\n\tsed -i CMakeLists.txt -e "/^project(tcpdump C)/a set(CMAKE_FIND_LIBRARY_SUFFIXES .a .so)"\n}' && \
    abuild -F fetch verify unpack prepare mkusers deps build package undeps && \
    "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/tcpdump" -h && \
    "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/tcpdump" -D && \
    strip "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/tcpdump" -o /usr/local/bin/tcpdump

FROM scratch
COPY --from=build /usr/local/bin/tcpdump /
ENTRYPOINT ["/tcpdump"]
