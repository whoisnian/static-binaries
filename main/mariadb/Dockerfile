# syntax=docker.io/docker/dockerfile:1.14
# https://docs.docker.com/build/dockerfile/frontend/

ARG ALPINE_VERSION=3.21
ARG PACKAGE_PATH=main/mariadb
ARG PACKAGE_NAME=mariadb
ARG PACKAGE_VERSION=11.4.5

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

# mariadb-client depends (8)
#   mariadb-common
#   so:libc.musl-x86_64.so.1
#   so:libcrypto.so.3 => libcrypto.a provided by openssl-libs-static
#   so:libgcc_s.so.1
#   so:libncursesw.so.6 => libncursesw.a provided by ncurses-static
#   so:libssl.so.3 => libssl.a provided by openssl-libs-static
#   so:libstdc++.so.6 => libstdc++.a provided by libstdc++-dev
#   so:libz.so.1 => libz.a provided by zlib-static
ARG EXTRA_DEPS="ncurses-static openssl-libs-static zlib-static"

# STEP-1: install dependencies
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$BUILDARCH,sharing=locked \
  wget -O "${PACKAGE_NAME}.tar.gz" "https://gitlab.alpinelinux.org/alpine/aports/-/archive/${ALPINE_VERSION}-stable/aports-${ALPINE_VERSION}-stable.tar.gz?path=${PACKAGE_PATH}" && \
  tar -xf "${PACKAGE_NAME}.tar.gz" --strip-components=1 && cd "${PACKAGE_PATH}" && \
  grep -q "pkgver=${PACKAGE_VERSION}" APKBUILD && echo 'pkgver matched' && \
  abuild -F deps && apk add ${EXTRA_DEPS}

# STEP-2: build executable
# source url from https://www.linuxfromscratch.org/blfs/view/stable-systemd/server/mariadb.html
RUN --mount=type=cache,target=/var/cache/distfiles <<EOT
  set -ex
  cd "${PACKAGE_PATH}"
  export LDFLAGS=-static
  sed -i APKBUILD -e 's|https://rsync.osuosl.org/pub/mariadb|https://downloads.mariadb.org/interstitial|'
  sed -i APKBUILD -e 's|cmake -B build -G Ninja -Wno-dev|& -DWITHOUT_SERVER=ON -DDISABLE_SHARED=ON|'
  sed -i APKBUILD -e 's|-DPLUGIN_\([^=]\+\)=[^ ]\+ |-DPLUGIN_\1=NO |'
  sed -i APKBUILD -e 's|cmake --build build$|& --target mariadb mariadb-dump|'
  sed -i APKBUILD -e 's|cmake --install build$|& --component ClientCompiled|'
  sed -i APKBUILD -e 's/mv .*\/My\/SafeProcess\/my_safe_process /true || &/'
  sed -i APKBUILD -e 's/ln -s .*\/bin\/my_safe_process /true || &/'
  sed -i APKBUILD -e 's|rm \\$|rm -f \\|'
  sed -i APKBUILD -e '/^build()/i \
prepare() {\
	default_prepare\
	sed -i cmake/ssl.cmake -e "/FIND_PACKAGE(OpenSSL)/i \\    SET(OPENSSL_USE_STATIC_LIBS TRUE)"\
	sed -i client/CMakeLists.txt -e "/^MYSQL_ADD_EXECUTABLE(mariadb /,/)$/ {s|)$| COMPONENT ClientCompiled)|}"\
	sed -i client/CMakeLists.txt -e "s|^MYSQL_ADD_EXECUTABLE(mariadb-dump [^)]\\+|& COMPONENT ClientCompiled|"\
}'
  abuild -F fetch verify unpack prepare mkusers build package
EOT

# STEP-3: test executable
# /usr/bin/mysql -> mariadb
# /usr/bin/mysqldump -> mariadb-dump
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$BUILDARCH,sharing=locked \
  cd "${PACKAGE_PATH}" && apk del ${EXTRA_DEPS} && abuild -F undeps && \
  "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/mariadb" --help && \
  file "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/mariadb" | grep -q 'statically linked' && \
  strip "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/mariadb" -o /usr/local/bin/mariadb && \
  "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/mariadb-dump" --help && \
  file "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/mariadb-dump" | grep -q 'statically linked' && \
  strip "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/mariadb-dump" -o /usr/local/bin/mariadb-dump

# STEP-4: export executable
# https://docs.docker.com/reference/cli/docker/buildx/build/#local
FROM scratch
COPY --from=build /usr/local/bin/mariadb /usr/local/bin/mariadb-dump /
ENTRYPOINT ["/mariadb"]

########## CHANGES ##########
# 20250330:
#   * Enable static build via LDFLAGS and OPENSSL_USE_STATIC_LIBS
#   * Disable server and plugin build via cmake options
#   * Ignore install error for components not built
#   * Build and output only mariadb and mariadb-dump executables
