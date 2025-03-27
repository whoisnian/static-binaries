# syntax=docker.io/docker/dockerfile:1.14
# https://docs.docker.com/build/dockerfile/frontend/

ARG ALPINE_VERSION=3.21.3
ARG PACKAGE_PATH=main/htop
ARG PACKAGE_NAME=htop
ARG PACKAGE_VERSION=3.3.0

FROM docker.io/library/alpine:${ALPINE_VERSION} AS build

# https://docs.docker.com/build/building/variables/#scoping
ARG BUILDARCH
ARG ALPINE_VERSION
ARG PACKAGE_PATH
ARG PACKAGE_NAME
ARG PACKAGE_VERSION

# depends (2)
#   so:libc.musl-x86_64.so.1
#   so:libncursesw.so.6 => libncursesw.a provided by ncurses-static
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$BUILDARCH,sharing=locked \
    ln -s /var/cache/apk /etc/apk/cache && apk upgrade && apk add \
    alpine-sdk ncurses-static

WORKDIR /src
RUN --mount=type=cache,target=/var/cache/apk,id=apk-$BUILDARCH,sharing=locked \
    wget -O "${PACKAGE_NAME}.tar.gz" "https://gitlab.alpinelinux.org/alpine/aports/-/archive/v${ALPINE_VERSION}/aports-v${ALPINE_VERSION}.tar.gz?path=${PACKAGE_PATH}" && \
    tar -xf "${PACKAGE_NAME}.tar.gz" --strip-components=1 && \
    cd "${PACKAGE_PATH}" && grep -q "pkgver=${PACKAGE_VERSION}" APKBUILD && echo 'pkgver matched' && \
    sed -i APKBUILD -e 's|./configure|./configure --enable-static|' && \
    abuild -F fetch verify unpack prepare deps build package undeps && \
    "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/htop" -h && \
    strip "/src/${PACKAGE_PATH}/pkg/${PACKAGE_NAME}/usr/bin/htop" -o /usr/local/bin/htop

FROM scratch
COPY --from=build /usr/local/bin/htop /
ENTRYPOINT ["/htop"]
