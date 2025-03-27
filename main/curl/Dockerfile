# syntax=docker.io/docker/dockerfile:1.14
# https://docs.docker.com/build/dockerfile/frontend/

ARG ALPINE_VERSION=3.21.3
ARG PACKAGE_PATH=main/curl
ARG PACKAGE_NAME=curl
ARG PACKAGE_VERSION=8.12.1

FROM docker.io/library/alpine:${ALPINE_VERSION} AS build

# https://docs.docker.com/build/building/variables/#scoping
ARG BUILDARCH
ARG ALPINE_VERSION
ARG PACKAGE_PATH
ARG PACKAGE_NAME
ARG PACKAGE_VERSION

# curl depends (4)
#   libcurl
#   so:libc.musl-x86_64.so.1
#   so:libcurl.so.4
#   so:libz.so.1 => libz.a provided by zlib-static
# libcurl depends (11)
#   ca-certificates-bundle
#   so:libbrotlidec.so.1 => libbrotlidec.a provided by brotli-static
#   so:libc.musl-x86_64.so.1
#   so:libcares.so.2 => libcares.a provided by c-ares-dev
#   so:libcrypto.so.3 => libcrypto.a provided by openssl-libs-static
#   so:libidn2.so.0 => libidn2.a provided by libidn2-static
#   so:libnghttp2.so.14 => libnghttp2.a provided by nghttp2-static
#   so:libpsl.so.5 => libpsl.a provided by libpsl-static
#   so:libssl.so.3 => libssl.a provided by openssl-libs-static
#   so:libz.so.1 => libz.a provided by zlib-static
#   so:libzstd.so.1 => libzstd.a provided by zstd-static
# libidn2 depends (2)
#   so:libc.musl-x86_64.so.1
#   so:libunistring.so.5 => libunistring.a provided by libunistring-static
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$BUILDARCH,sharing=locked \
    ln -s /var/cache/apk /etc/apk/cache && apk upgrade && apk add \
    alpine-sdk brotli-static libidn2-static libpsl-static nghttp2-static openssl-libs-static zlib-static zstd-static \
    libunistring-dev libunistring-static

# https://gitlab.alpinelinux.org/alpine/aports/-/issues/16622
# c-ares-dev-1.34.3 contains libcares_static.a but not libcares.a, fixed in c-ares-dev-1.34.4
WORKDIR /src
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$BUILDARCH,sharing=locked \
    wget -O "${PACKAGE_NAME}.tar.gz" "https://gitlab.alpinelinux.org/alpine/aports/-/archive/v${ALPINE_VERSION}/aports-v${ALPINE_VERSION}.tar.gz?path=${PACKAGE_PATH}" && \
    tar -xf "${PACKAGE_NAME}.tar.gz" --strip-components=1 && \
    cd "${PACKAGE_PATH}" && grep -q "pkgver=${PACKAGE_VERSION}" APKBUILD && echo 'pkgver matched' && \
    ln -s libcares_static.a /usr/lib/libcares.a && \
    sed -i APKBUILD -e 's|./configure|LDFLAGS=-static PKG_CONFIG="pkg-config --static" ./configure --disable-shared --with-brotli|' && \
    sed -i APKBUILD -e 's|make$|make LDFLAGS=-all-static|' && \
    abuild -F fetch verify unpack prepare deps build package undeps && \
    "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/curl" -h && \
    strip "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/curl" -o /usr/local/bin/curl
 
FROM scratch
COPY --from=build /usr/local/bin/curl /
ENTRYPOINT ["/curl"]
