# syntax=docker.io/docker/dockerfile:1.14
# https://docs.docker.com/build/dockerfile/frontend/

ARG ALPINE_VERSION=3.21.3
ARG PACKAGE_PATH=main/postgresql17
ARG PACKAGE_NAME=postgresql17
ARG PACKAGE_VERSION=17.2

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

# postgresql17-client depends (8)
#   postgresql-common
#   so:libc.musl-x86_64.so.1
#   so:libcrypto.so.3 => libcrypto.a provided by openssl-libs-static
#   so:liblz4.so.1 => liblz4.a provided by lz4-static
#   so:libpq.so.5 => libpq.a provided by libpq-dev
#   so:libreadline.so.8 => libreadline.a provided by readline-static
#   so:libz.so.1 => libz.a provided by zlib-static
#   so:libzstd.so.1 => libzstd.a provided by zstd-static
# ./configure
#   --with-readline => libncursesw.a provided by ncurses-static
#   --with-libxml => libxml2.a provided by libxml2-static; liblzma.a provided by xz-static
#   --with-uuid=e2fs => libuuid.a provided by util-linux-static
ARG EXTRA_DEPS="libxml2-static lz4-static ncurses-static openssl-libs-static readline-static util-linux-static xz-static zlib-static zstd-static"

# STEP-1: install dependencies
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$BUILDARCH,sharing=locked \
  wget -O "${PACKAGE_NAME}.tar.gz" "https://gitlab.alpinelinux.org/alpine/aports/-/archive/v${ALPINE_VERSION}/aports-v${ALPINE_VERSION}.tar.gz?path=${PACKAGE_PATH}" && \
  tar -xf "${PACKAGE_NAME}.tar.gz" --strip-components=1 && cd "${PACKAGE_PATH}" && \
  grep -q "pkgver=${PACKAGE_VERSION}" APKBUILD && echo 'pkgver matched' && \
  abuild -F deps && apk add ${EXTRA_DEPS}

# STEP-2: build executable
# LDFLAGS_EX
#   -lpq -lpgcommon_shlib -lpgport_shlib: from https://www.postgresql.org/message-id/CAAwAxZf456NwLKD4ZBpyDmPc5GFmGP%3Db5Vw7pTMY0v9R-%3D%2BDTA%40mail.gmail.com
#   -lreadline -lncursesw: from pkg-config --libs --static readline
# ./configure from https://www.postgresql.org/docs/17/install-make.html#CONFIGURE-OPTIONS-FEATURES
#   --with-llvm: Build with support for LLVM based JIT compilation
#   --with-perl: Build the PL/Perl server-side language
#   --with-python: Build the PL/Python server-side language
#   --with-tcl: Build the PL/Tcl server-side language
#   --with-ldap: Build with LDAP support for authentication and connection parameter lookup
RUN --mount=type=cache,target=/var/cache/distfiles <<EOT
  set -ex
  cd "${PACKAGE_PATH}"
  export LDFLAGS_EX="-static -lpq -lpgcommon_shlib -lpgport_shlib -lreadline -lncursesw"
  sed -i APKBUILD -e 's|_default_ver=true|_default_ver=false|'
  sed -i APKBUILD -e '/patch -p1 .*\/external-libpq.patch.txt/d'
  sed -i APKBUILD -e 's|--with-llvm|--without-llvm|'
  sed -i APKBUILD -e 's|--with-perl|--without-perl|'
  sed -i APKBUILD -e 's|--with-python|--without-python|'
  sed -i APKBUILD -e 's|--with-tcl|--without-tcl|'
  sed -i APKBUILD -e 's|--with-ldap|--without-ldap|'
  sed -i APKBUILD -e 's|make world$|make -C src/interfaces/libpq\n\tmake -C src/bin/psql\n\tmake -C src/bin/pg_dump|'
  sed -i APKBUILD -e 's|make \(.*\) install install-docs$|make \1 -C src/bin/psql install\n\tmake \1 -C src/bin/pg_dump install|'
  sed -i APKBUILD -e '/server_cmds/d'
  abuild -F fetch verify unpack prepare mkusers build package
EOT

# STEP-3: test executable
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$BUILDARCH,sharing=locked \
  cd "${PACKAGE_PATH}" && apk del ${EXTRA_DEPS} && abuild -F undeps && \
  "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/libexec/${PACKAGE_NAME}/psql" --help && \
  file "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/libexec/${PACKAGE_NAME}/psql" | grep -q 'statically linked' && \
  strip "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/libexec/${PACKAGE_NAME}/psql" -o /usr/local/bin/psql && \
  "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/libexec/${PACKAGE_NAME}/pg_dump" --help && \
  file "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/libexec/${PACKAGE_NAME}/pg_dump" | grep -q 'statically linked' && \
  strip "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/libexec/${PACKAGE_NAME}/pg_dump" -o /usr/local/bin/pg_dump

# STEP-4: export executable
# https://docs.docker.com/reference/cli/docker/buildx/build/#local
FROM scratch
COPY --from=build /usr/local/bin/p* /
ENTRYPOINT ["/psql"]
