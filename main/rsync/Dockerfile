# syntax=docker.io/docker/dockerfile:1.14
# https://docs.docker.com/build/dockerfile/frontend/

ARG ALPINE_VERSION=3.21
ARG PACKAGE_PATH=main/rsync
ARG PACKAGE_NAME=rsync
ARG PACKAGE_VERSION=3.4.0

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

# rsync depends (7)
#   so:libacl.so.1 => libacl.a provided by acl-static
#   so:libc.musl-x86_64.so.1
#   so:liblz4.so.1 => liblz4.a provided by lz4-static
#   so:libpopt.so.0 => libpopt.a provided by popt-static
#   so:libxxhash.so.0 => libxxhash.a not found
#   so:libz.so.1 => libz.a provided by zlib-static
#   so:libzstd.so.1 => libzstd.a provided by zstd-static
ARG EXTRA_DEPS="acl-static lz4-static popt-static zlib-static zstd-static"

# STEP-1: install xxhash dependencies
ARG XXHASH_PATH=main/xxhash
ARG XXHASH_NAME=xxhash
ARG XXHASH_VERSION=0.8.2
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$BUILDARCH,sharing=locked \
  wget -O "${XXHASH_NAME}.tar.gz" "https://gitlab.alpinelinux.org/alpine/aports/-/archive/${ALPINE_VERSION}-stable/aports-${ALPINE_VERSION}-stable.tar.gz?path=${XXHASH_PATH}" && \
  tar -xf "${XXHASH_NAME}.tar.gz" --strip-components=1 && cd "${XXHASH_PATH}" && \
  grep -q "pkgver=${XXHASH_VERSION}" APKBUILD && echo 'pkgver matched' && \
  abuild -F deps

# STEP-2: build xxhash library
RUN --mount=type=cache,target=/var/cache/distfiles <<EOT
  set -ex
  cd "${XXHASH_PATH}"
  sed -i APKBUILD -e '/rm -rf "\$pkgdir"\/usr\/lib\/libxxhash.a/d'
  abuild -F fetch verify unpack prepare mkusers build package
EOT

# STEP-3: install dependencies
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$BUILDARCH,sharing=locked \
  wget -O "${PACKAGE_NAME}.tar.gz" "https://gitlab.alpinelinux.org/alpine/aports/-/archive/${ALPINE_VERSION}-stable/aports-${ALPINE_VERSION}-stable.tar.gz?path=${PACKAGE_PATH}" && \
  tar -xf "${PACKAGE_NAME}.tar.gz" --strip-components=1 && cd "${PACKAGE_PATH}" && \
  grep -q "pkgver=${PACKAGE_VERSION}" APKBUILD && echo 'pkgver matched' && \
  sed -i APKBUILD -e '/xxhash-dev/d' && \
  abuild -F deps && apk add ${EXTRA_DEPS}

# STEP-4: build executable
RUN --mount=type=cache,target=/var/cache/distfiles <<EOT
  set -ex
  cd "${PACKAGE_PATH}"
  export CFLAGS="-static -L/src/${XXHASH_PATH}/pkg/${XXHASH_NAME}/usr/lib"
  export CPPFLAGS="-I/src/${XXHASH_PATH}/pkg/${XXHASH_NAME}/usr/include"
  sed -i APKBUILD -e 's|https://download.samba.org/pub/rsync|https://download.samba.org/pub/rsync/src|'
  sed -i APKBUILD -e 's|make reconfigure$|make|'
  abuild -F fetch verify unpack prepare mkusers build package
EOT

# STEP-5: test executable
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$BUILDARCH,sharing=locked \
  cd "${PACKAGE_PATH}" && apk del ${EXTRA_DEPS} && abuild -F undeps && \
  "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/rsync" --help && \
  file "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/rsync" | grep -q 'statically linked' && \
  strip "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/rsync" -o /usr/local/bin/rsync

# STEP-6: export executable
# https://docs.docker.com/reference/cli/docker/buildx/build/#local
FROM scratch
COPY --from=build /usr/local/bin/rsync /
ENTRYPOINT ["/rsync"]

########## CHANGES ##########
# 20250403:
#   * Build libxxhash.a for configure --enable-xxhash
#   * Enable static build via CFLAGS and CPPFLAGS
#   * Remove ambiguous make reconfigure
#   * Output only rsync executable
