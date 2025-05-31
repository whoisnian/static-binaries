# syntax=docker.io/docker/dockerfile:1.16
# https://docs.docker.com/build/dockerfile/frontend/

ARG ALPINE_VERSION=3.22
ARG PACKAGE_PATH=main/nmap
ARG PACKAGE_NAME=nmap
ARG PACKAGE_VERSION=7.97

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

# nmap depends (9)
#   so:libc.musl-x86_64.so.1
#   so:libcrypto.so.3 => libcrypto.a provided by openssl-libs-static
#   so:libgcc_s.so.1
#   so:liblua-5.4.so.0
#   so:libpcap.so.1 => libpcap.a provided by libpcap-dev
#   so:libssh2.so.1 => libssh2.a provided by libssh2-static
#   so:libssl.so.3 => libssl.a provided by openssl-libs-static
#   so:libstdc++.so.6 => libstdc++.a provided by libstdc++-dev
#   so:libz.so.1 => libz.a provided by zlib-static
ARG EXTRA_DEPS="libssh2-static libstdc++-dev openssl-libs-static zlib-static"

# STEP-1: install dependencies
COPY aports "${PACKAGE_PATH}"
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$BUILDARCH,sharing=locked \
  cd "${PACKAGE_PATH}" && grep -q "pkgver=${PACKAGE_VERSION}" APKBUILD && echo 'pkgver matched' && \
  abuild -F deps && apk add ${EXTRA_DEPS}

# STEP-2: build executable
RUN --mount=type=cache,target=/var/cache/distfiles <<EOT
  set -ex
  cd "${PACKAGE_PATH}"
  export LDFLAGS=-static && export LIBS="$(pkg-config --libs --static libssh2)"
  sed -i APKBUILD -e 's|--without-zenmap|& --without-ndiff --without-nping --without-ncat|'
  abuild -F fetch verify unpack prepare mkusers build package
EOT

# STEP-3: test executable
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$BUILDARCH,sharing=locked \
  cd "${PACKAGE_PATH}" && apk del ${EXTRA_DEPS} && abuild -F undeps && \
  "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/nmap" -h && \
  file "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/nmap" | grep -q 'statically linked' && \
  strip "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/nmap" -o /usr/local/bin/nmap

# STEP-4: export executable
# https://docs.docker.com/reference/cli/docker/buildx/build/#local
FROM scratch
COPY --from=build /usr/local/bin/nmap /
ENTRYPOINT ["/nmap"]

########## CHANGES ##########
# 20250531:
#   * Upgrade nmap to 7.97
#   * Commit APKBUILD to git for reproducible build
# 20250404:
#   * Enable static build via LDFLAGS and LIBS
#   * Build and output only nmap executable
