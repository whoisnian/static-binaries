# syntax=docker.io/docker/dockerfile:1.16
# https://docs.docker.com/build/dockerfile/frontend/

ARG ALPINE_VERSION=3.22
ARG PACKAGE_PATH=main/iproute2
ARG PACKAGE_NAME=iproute2
ARG PACKAGE_VERSION=6.15.0

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

# iproute2-ss depends (3)
#   so:libc.musl-x86_64.so.1
#   so:libcap.so.2 => libcap.a provided by libcap-static
#   so:libmnl.so.0 => libmnl.a provided by libmnl-static
ARG EXTRA_DEPS="libcap-static libmnl-static"

# STEP-1: install dependencies
COPY aports "${PACKAGE_PATH}"
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$BUILDARCH,sharing=locked \
  cd "${PACKAGE_PATH}" && grep -q "pkgver=${PACKAGE_VERSION}" APKBUILD && echo 'pkgver matched' && \
  abuild -F deps && apk add ${EXTRA_DEPS}

# STEP-2: build executable
RUN --mount=type=cache,target=/var/cache/distfiles <<EOT
  set -ex
  cd "${PACKAGE_PATH}"
  export LDFLAGS=-static
  sed -i APKBUILD -e '/^build()/i \
prepare() {\
	default_prepare\
	sed -i Makefile -e "s|^SUBDIRS=.*$|SUBDIRS=lib misc|"\
	sed -i Makefile -e "/^SUBDIRS +=.*$/d"\
}'
  abuild -F fetch verify unpack prepare mkusers build package
EOT

# STEP-3: test executable
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$BUILDARCH,sharing=locked \
  cd "${PACKAGE_PATH}" && apk del ${EXTRA_DEPS} && abuild -F undeps && \
  "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/sbin/ss" --help && \
  file "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/sbin/ss" | grep -q 'statically linked' && \
  strip "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/sbin/ss" -o /usr/local/bin/ss

# STEP-4: export executable
# https://docs.docker.com/reference/cli/docker/buildx/build/#local
FROM scratch
COPY --from=build /usr/local/bin/ss /
ENTRYPOINT ["/ss"]

########## CHANGES ##########
# 20250531:
#   * Upgrade iproute2 to 6.15.0
#   * Commit APKBUILD to git for reproducible build
# 20250404:
#   * Enable static build via LDFLAGS
#   * Build and output only ss executable
