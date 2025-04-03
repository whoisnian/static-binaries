# syntax=docker.io/docker/dockerfile:1.14
# https://docs.docker.com/build/dockerfile/frontend/

ARG ALPINE_VERSION=3.21
ARG PACKAGE_PATH=main/iperf3
ARG PACKAGE_NAME=iperf3
ARG PACKAGE_VERSION=3.17.1

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

# iperf3 depends (2)
#   so:libc.musl-x86_64.so.1
#   so:libcrypto.so.3 => libcrypto.a provided by openssl-libs-static
ARG EXTRA_DEPS="openssl-libs-static"

# STEP-1: install dependencies
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$BUILDARCH,sharing=locked \
  wget -O "${PACKAGE_NAME}.tar.gz" "https://gitlab.alpinelinux.org/alpine/aports/-/archive/${ALPINE_VERSION}-stable/aports-${ALPINE_VERSION}-stable.tar.gz?path=${PACKAGE_PATH}" && \
  tar -xf "${PACKAGE_NAME}.tar.gz" --strip-components=1 && cd "${PACKAGE_PATH}" && \
  grep -q "pkgver=${PACKAGE_VERSION}" APKBUILD && echo 'pkgver matched' && \
  abuild -F deps && apk add ${EXTRA_DEPS}

# STEP-2: build executable
RUN --mount=type=cache,target=/var/cache/distfiles <<EOT
  set -ex
  cd "${PACKAGE_PATH}"
  sed -i APKBUILD -e 's|--disable-static|& --disable-shared --enable-static-bin|'
  abuild -F fetch verify unpack prepare mkusers build package
EOT

# STEP-3: test executable
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$BUILDARCH,sharing=locked \
  cd "${PACKAGE_PATH}" && apk del ${EXTRA_DEPS} && abuild -F undeps && \
  "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/iperf3" --help && \
  file "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/iperf3" | grep -q 'statically linked' && \
  strip "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/iperf3" -o /usr/local/bin/iperf3

# STEP-4: export executable
# https://docs.docker.com/reference/cli/docker/buildx/build/#local
FROM scratch
COPY --from=build /usr/local/bin/iperf3 /
ENTRYPOINT ["/iperf3"]

########## CHANGES ##########
# 20250404:
#   * Enable static build via configure options
