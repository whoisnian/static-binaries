# syntax=docker.io/docker/dockerfile:1.16
# https://docs.docker.com/build/dockerfile/frontend/

ARG ALPINE_VERSION=3.22
ARG PACKAGE_PATH=community/redis
ARG PACKAGE_NAME=redis
ARG PACKAGE_VERSION=8.0.4

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

# redis depends (5)
#   /bin/sh
#   so:libc.musl-x86_64.so.1
#   so:libcrypto.so.3 => libcrypto.a provided by openssl-libs-static
#   so:libssl.so.3 => libssl.a provided by openssl-libs-static
#   so:libstdc++.so.6 => libstdc++.a provided by libstdc++-dev
ARG EXTRA_DEPS="openssl-libs-static libstdc++-dev"

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
  sed -i APKBUILD -e 's|all$|redis-cli|'
  sed -i APKBUILD -e '/^build()/i \
prepare() {\
	default_prepare\
	sed -i src/Makefile -e "s|install: all|install:|"\
	sed -i src/Makefile -e "/call MAKE_INSTALL,\\\$(REDIS_SERVER_NAME)/d"\
	sed -i src/Makefile -e "/call MAKE_INSTALL,\\\$(REDIS_BENCHMARK_NAME)/d"\
}'
  abuild -F fetch verify unpack prepare mkusers build package
EOT

# STEP-3: test executable
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$BUILDARCH,sharing=locked \
  cd "${PACKAGE_PATH}" && apk del ${EXTRA_DEPS} && abuild -F undeps && \
  "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/redis-cli" --help && \
  file "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/redis-cli" | grep -q 'statically linked' && \
  strip "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/redis-cli" -o /usr/local/bin/redis-cli

# STEP-4: export executable
# https://docs.docker.com/reference/cli/docker/buildx/build/#local
FROM scratch
COPY --from=build /usr/local/bin/redis-cli /
ENTRYPOINT ["/redis-cli"]

########## CHANGES ##########
# 20251015:
#   * Upgrade redis to 8.0.4
# 20250531:
#   * Upgrade redis to 8.0.2
#   * Commit APKBUILD to git for reproducible build
# 20250329:
#   * Enable static build via CFLAGS and LDFLAGS
#   * Build and output only redis-cli executable
