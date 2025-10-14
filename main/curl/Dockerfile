# syntax=docker.io/docker/dockerfile:1.16
# https://docs.docker.com/build/dockerfile/frontend/

ARG ALPINE_VERSION=3.22
ARG PACKAGE_PATH=main/curl
ARG PACKAGE_NAME=curl
ARG PACKAGE_VERSION=8.14.1

FROM docker.io/library/alpine:${ALPINE_VERSION} AS build

# redeclare in build stage to inherit arguments from global scope
# https://docs.docker.com/build/building/variables/#scoping
ARG BUILDARCH
ARG ALPINE_VERSION
ARG PACKAGE_PATH
ARG PACKAGE_NAME
ARG PACKAGE_VERSION

# alpine-sdk: abuild git build-base(binutils file gcc g++ make libc-dev fortify-headers patch)
WORKDIR /src
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$BUILDARCH,sharing=locked \
  ln -s /var/cache/apk /etc/apk/cache && apk upgrade && apk add alpine-sdk

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
ARG EXTRA_DEPS="brotli-static libidn2-static libpsl-static nghttp2-static openssl-libs-static zlib-static zstd-static libunistring-dev libunistring-static"

# STEP-1: install dependencies
COPY aports "${PACKAGE_PATH}"
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$BUILDARCH,sharing=locked \
  cd "${PACKAGE_PATH}" && grep -q "pkgver=${PACKAGE_VERSION}" APKBUILD && echo 'pkgver matched' && \
  abuild -F deps && apk add ${EXTRA_DEPS}

# STEP-2: build executable
RUN --mount=type=cache,target=/var/cache/distfiles <<EOT
  set -ex
  cd "${PACKAGE_PATH}"
  sed -i APKBUILD -e 's|./configure|LDFLAGS=-static PKG_CONFIG="pkg-config --static" ./configure --disable-shared --with-brotli|'
  sed -i APKBUILD -e 's|make$|make LDFLAGS=-all-static|'
  abuild -F fetch verify unpack prepare mkusers build package
EOT

# STEP-3: test executable
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$BUILDARCH,sharing=locked \
  cd "${PACKAGE_PATH}" && apk del ${EXTRA_DEPS} && abuild -F undeps && \
  "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/curl" --help && \
  file "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/curl" | grep -q 'statically linked' && \
  strip "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/curl" -o /usr/local/bin/curl

# STEP-4: export executable
# https://docs.docker.com/reference/cli/docker/buildx/build/#local
FROM scratch
COPY --from=build /usr/local/bin/curl /
ENTRYPOINT ["/curl"]

########## CHANGES ##########
# 20251015:
#   * Upgrade curl to 8.14.1
# 20250531:
#   * Upgrade curl to 8.14.0
#   * Commit APKBUILD to git for reproducible build
# 20250327:
#   * Enable static build via LDFLAGS and PKG_CONFIG
#   * Patch c-ares-dev-1.34.3(libcares_static.a) for static build
