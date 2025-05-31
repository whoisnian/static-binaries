# syntax=docker.io/docker/dockerfile:1.16
# https://docs.docker.com/build/dockerfile/frontend/

ARG ALPINE_VERSION=3.22
ARG PACKAGE_PATH=main/procps-ng
ARG PACKAGE_NAME=procps-ng
ARG PACKAGE_VERSION=4.0.4

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

# procps-ng depends (5)
#   so:libc.musl-x86_64.so.1
#   so:libintl.so.8 => libintl.a provided by gettext-static
#   so:libncursesw.so.6 => libncursesw.a provided by ncurses-static
#   so:libproc2.so.0
#   so:libutmps.so.0.1 => libutmps.a provided by utmps-static
ARG EXTRA_DEPS="gettext-static ncurses-static utmps-static"

# STEP-1: install dependencies
COPY aports "${PACKAGE_PATH}"
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$BUILDARCH,sharing=locked \
  cd "${PACKAGE_PATH}" && grep -q "pkgver=${PACKAGE_VERSION}" APKBUILD && echo 'pkgver matched' && \
  abuild -F deps && apk add ${EXTRA_DEPS}

# STEP-2: build executable
RUN --mount=type=cache,target=/var/cache/distfiles <<EOT
  set -ex
  cd "${PACKAGE_PATH}"
  export LDFLAGS=--static
  sed -i APKBUILD -e 's|--disable-static|--enable-static --disable-shared|'
  abuild -F fetch verify unpack prepare mkusers build package
EOT

# STEP-3: test executable
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$BUILDARCH,sharing=locked \
  cd "${PACKAGE_PATH}" && apk del ${EXTRA_DEPS} && abuild -F undeps && \
  "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/bin/ps" --help && \
  file "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/bin/ps" | grep -q 'statically linked' && \
  strip "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/bin/ps" -o /usr/local/bin/ps

# STEP-4: export executable
# https://docs.docker.com/reference/cli/docker/buildx/build/#local
FROM scratch
COPY --from=build /usr/local/bin/ps /
ENTRYPOINT ["/ps"]

########## CHANGES ##########
# 20250531:
#   * Upgrade alpine image to 3.22
#   * Commit APKBUILD to git for reproducible build
# 20250401:
#   * Enable static build via configure options
#   * Output only ps executable
