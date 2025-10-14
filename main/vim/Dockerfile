# syntax=docker.io/docker/dockerfile:1.16
# https://docs.docker.com/build/dockerfile/frontend/

ARG ALPINE_VERSION=3.22
ARG PACKAGE_PATH=main/vim
ARG PACKAGE_NAME=vim
ARG PACKAGE_VERSION=9.1.1566

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

# vim depends (2)
#   vim-common
#   xxd
#   so:libc.musl-x86_64.so.1
#   so:libncursesw.so.6 => libncursesw.a provided by ncurses-static
ARG EXTRA_DEPS="ncurses-static"

# STEP-1: install dependencies
COPY aports "${PACKAGE_PATH}"
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$BUILDARCH,sharing=locked \
  cd "${PACKAGE_PATH}" && grep -q "pkgver=${PACKAGE_VERSION}" APKBUILD && echo 'pkgver matched' && \
  abuild -F deps && apk add ${EXTRA_DEPS}

# STEP-2: build executable
RUN --mount=type=cache,target=/var/cache/distfiles <<EOT
  set -ex
  cd "${PACKAGE_PATH}"
  export CFLAGS=-static && export LDFLAGS=-static
  sed -i APKBUILD -e 's|--enable-\([a-zA-Z0-9]\+\)interp=[^ ]\+ |--enable-\1interp=no |'
  sed -i APKBUILD -e '/cp -r "\$builddir" "\$builddir"-gvim/d'
  sed -i APKBUILD -e '/cd "\$builddir"-gvim/,/make$/d'
  abuild -F fetch verify unpack prepare mkusers build package
EOT

# STEP-3: test executable
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$BUILDARCH,sharing=locked \
  cd "${PACKAGE_PATH}" && apk del ${EXTRA_DEPS} && abuild -F undeps && \
  "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/vim" -h && \
  file "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/vim" | grep -q 'statically linked' && \
  strip "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/vim" -o /usr/local/bin/vim && \
  "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/xxd" -v && \
  file "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/xxd" | grep -q 'statically linked' && \
  strip "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/xxd" -o /usr/local/bin/xxd

# STEP-4: export executable
# https://docs.docker.com/reference/cli/docker/buildx/build/#local
FROM scratch
COPY --from=build /usr/local/bin/vim /usr/local/bin/xxd /
ENTRYPOINT ["/vim"]

########## CHANGES ##########
# 20251015:
#   * Upgrade vim to 9.1.1566
# 20250531:
#   * Upgrade vim to 9.1.1415
#   * Commit APKBUILD to git for reproducible build
# 20250403:
#   * Enable static build via CFLAGS and LDFLAGS
#   * Disable Lua/Python3/Ruby interpreters
#   * Remove gvim makedepends and gvim build
#   * Output only vim and xxd executables
