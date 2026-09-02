# syntax=docker.io/docker/dockerfile:1.25
# https://docs.docker.com/build/dockerfile/frontend/

ARG ALPINE_VERSION=3.24
ARG PACKAGE_PATH=main/rsync
ARG PACKAGE_NAME=rsync
ARG PACKAGE_VERSION=3.5.0

FROM docker.io/library/alpine:${ALPINE_VERSION} AS build

# redeclare in build stage to inherit arguments from global scope
# https://docs.docker.com/build/building/variables/#scoping
ARG TARGETARCH
ARG ALPINE_VERSION
ARG PACKAGE_PATH
ARG PACKAGE_NAME
ARG PACKAGE_VERSION

# alpine-sdk: abuild git build-base(binutils file gcc g++ make libc-dev fortify-headers patch)
WORKDIR /src
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$TARGETARCH,sharing=locked \
  ln -s /var/cache/apk /etc/apk/cache && apk upgrade && apk add alpine-sdk

# rsync depends (7)
#   so:libacl.so.1 => libacl.a provided by acl-static
#   so:libc.musl-x86_64.so.1
#   so:liblz4.so.1 => liblz4.a provided by lz4-static
#   so:libpopt.so.0 => libpopt.a provided by popt-static
#   so:libxxhash.so.0 => libxxhash.a provided by xxhash-static
#   so:libz.so.1 => libz.a provided by zlib-static
#   so:libzstd.so.1 => libzstd.a provided by zstd-static
ARG EXTRA_DEPS="acl-static lz4-static popt-static xxhash-static zlib-static zstd-static"

# STEP-1: install dependencies
COPY aports "${PACKAGE_PATH}"
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$TARGETARCH,sharing=locked \
  cd "${PACKAGE_PATH}" && grep -q "pkgver=${PACKAGE_VERSION}" APKBUILD && echo 'pkgver matched' && \
  abuild -F deps && apk add ${EXTRA_DEPS}

# STEP-2: build executable
RUN --mount=type=cache,target=/var/cache/distfiles <<EOT
  set -ex
  cd "${PACKAGE_PATH}"
  export CFLAGS=-static
  sed -i APKBUILD -e 's|https://download.samba.org/pub/rsync|https://download.samba.org/pub/rsync/src|'
  abuild -F fetch verify unpack prepare mkusers build package
EOT

# STEP-3: test executable
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$TARGETARCH,sharing=locked \
  cd "${PACKAGE_PATH}" && apk del ${EXTRA_DEPS} && abuild -F undeps && \
  "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/rsync" --help && \
  file "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/rsync" | grep -q 'static-pie linked\|statically linked' && \
  strip "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/rsync" -o /usr/local/bin/rsync

# STEP-4: export executable
# https://docs.docker.com/reference/cli/docker/buildx/build/#local
FROM scratch
COPY --from=build /usr/local/bin/rsync /
ENTRYPOINT ["/rsync"]

########## CHANGES ##########
# 20260901:
#   * Upgrade rsync to 3.5.0
#   * Upgrade alpine image to 3.24
#   * Use libxxhash.a from official xxhash-static
# 20260227:
#   * Upgrade alpine image to 3.23
# 20250531:
#   * Upgrade rsync to 3.4.1
#   * Commit APKBUILD to git for reproducible build
# 20250403:
#   * Build libxxhash.a for configure --enable-xxhash
#   * Enable static build via CFLAGS and CPPFLAGS
#   * Remove ambiguous make reconfigure
#   * Output only rsync executable
