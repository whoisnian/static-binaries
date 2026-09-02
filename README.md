# static-binaries
[![Release Status](https://github.com/whoisnian/static-binaries/actions/workflows/release.yml/badge.svg)](https://github.com/whoisnian/static-binaries/actions/workflows/release.yml)
[![Release Version](https://img.shields.io/github/v/release/whoisnian/static-binaries?label=version)](https://github.com/whoisnian/static-binaries/releases/latest)

Build static binaries based on Alpine Linux packages.

## Binaries
Last build: `2026-09-02T17:55:42Z` with Alpine Linux `v3.24`

| binary       | package                                                                                               | version  | download                                                                                                                                                                                                                                            |
| ------------ | ----------------------------------------------------------------------------------------------------- | -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| fio          | [community/fio](https://pkgs.alpinelinux.org/package/edge/community/x86_64/fio)                       | 3.41     | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/fio_v20260901.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/fio_v20260901.0_linux_arm64)                   |
| qrencode     | [community/libqrencode](https://pkgs.alpinelinux.org/package/edge/community/x86_64/libqrencode-tools) | 4.1.1    | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/qrencode_v20260901.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/qrencode_v20260901.0_linux_arm64)         |
| redis-cli    | [community/redis](https://pkgs.alpinelinux.org/package/edge/community/x86_64/redis)                   | 8.8.0    | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/redis-cli_v20260901.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/redis-cli_v20260901.0_linux_arm64)       |
| vim          | [community/vim](https://pkgs.alpinelinux.org/package/edge/community/x86_64/vim)                       | 9.2.1014 | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/vim_v20260901.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/vim_v20260901.0_linux_arm64)                   |
| 7z           | [main/7zip](https://pkgs.alpinelinux.org/package/edge/main/x86_64/7zip)                               | 26.01    | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/7z_v20260901.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/7z_v20260901.0_linux_arm64)                     |
| curl         | [main/curl](https://pkgs.alpinelinux.org/package/edge/main/x86_64/curl)                               | 8.22.0   | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/curl_v20260901.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/curl_v20260901.0_linux_arm64)                 |
| htop         | [main/htop](https://pkgs.alpinelinux.org/package/edge/main/x86_64/htop)                               | 3.5.3    | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/htop_v20260901.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/htop_v20260901.0_linux_arm64)                 |
| iperf3       | [main/iperf3](https://pkgs.alpinelinux.org/package/edge/main/x86_64/iperf3)                           | 3.20     | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/iperf3_v20260901.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/iperf3_v20260901.0_linux_arm64)             |
| ss           | [main/iproute2](https://pkgs.alpinelinux.org/package/edge/main/x86_64/iproute2-ss)                    | 7.0.0    | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/ss_v20260901.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/ss_v20260901.0_linux_arm64)                     |
| lsof         | [main/lsof](https://pkgs.alpinelinux.org/package/edge/main/x86_64/lsof)                               | 4.99.6   | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/lsof_v20260901.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/lsof_v20260901.0_linux_arm64)                 |
| mariadb      | [main/mariadb](https://pkgs.alpinelinux.org/package/edge/main/x86_64/mariadb-client)                  | 11.8.8   | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/mariadb_v20260901.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/mariadb_v20260901.0_linux_arm64)           |
| mariadb-dump | [main/mariadb](https://pkgs.alpinelinux.org/package/edge/main/x86_64/mariadb-client)                  | 11.8.8   | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/mariadb-dump_v20260901.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/mariadb-dump_v20260901.0_linux_arm64) |
| nano         | [main/nano](https://pkgs.alpinelinux.org/package/edge/main/x86_64/nano)                               | 9.2      | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/nano_v20260901.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/nano_v20260901.0_linux_arm64)                 |
| nc           | [main/netcat-openbsd](https://pkgs.alpinelinux.org/package/edge/main/x86_64/netcat-openbsd)           | 1.234-1  | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/nc_v20260901.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/nc_v20260901.0_linux_arm64)                     |
| nmap         | [main/nmap](https://pkgs.alpinelinux.org/package/edge/main/x86_64/nmap)                               | 7.99     | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/nmap_v20260901.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/nmap_v20260901.0_linux_arm64)                 |
| pigz         | [main/pigz](https://pkgs.alpinelinux.org/package/edge/main/x86_64/pigz)                               | 2.8      | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/pigz_v20260901.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/pigz_v20260901.0_linux_arm64)                 |
| psql         | [main/postgresql17](https://pkgs.alpinelinux.org/package/edge/main/x86_64/postgresql17-client)        | 17.11    | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/psql_v20260901.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/psql_v20260901.0_linux_arm64)                 |
| pg_dump      | [main/postgresql17](https://pkgs.alpinelinux.org/package/edge/main/x86_64/postgresql17-client)        | 17.11    | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/pg_dump_v20260901.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/pg_dump_v20260901.0_linux_arm64)           |
| ps           | [main/procps-ng](https://pkgs.alpinelinux.org/package/edge/main/x86_64/procps-ng)                     | 4.0.6    | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/ps_v20260901.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/ps_v20260901.0_linux_arm64)                     |
| rsync        | [main/rsync](https://pkgs.alpinelinux.org/package/edge/main/x86_64/rsync)                             | 3.5.0    | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/rsync_v20260901.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/rsync_v20260901.0_linux_arm64)               |
| socat        | [main/socat](https://pkgs.alpinelinux.org/package/edge/main/x86_64/socat)                             | 1.8.1.3  | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/socat_v20260901.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/socat_v20260901.0_linux_arm64)               |
| strace       | [main/strace](https://pkgs.alpinelinux.org/package/edge/main/x86_64/strace)                           | 6.19     | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/strace_v20260901.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/strace_v20260901.0_linux_arm64)             |
| tcpdump      | [main/tcpdump](https://pkgs.alpinelinux.org/package/edge/main/x86_64/tcpdump)                         | 4.99.6   | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/tcpdump_v20260901.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/tcpdump_v20260901.0_linux_arm64)           |
| xxd          | [main/vim](https://pkgs.alpinelinux.org/package/edge/main/x86_64/xxd)                                 |          | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/xxd_v20260901.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/xxd_v20260901.0_linux_arm64)                   |
| wget         | [main/wget](https://pkgs.alpinelinux.org/package/edge/main/x86_64/wget)                               | 1.25.0   | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/wget_v20260901.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/wget_v20260901.0_linux_arm64)                 |
| mysql80      | [custom/mysql80](https://aur.archlinux.org/packages/mysql80)                                          | 8.0.45   | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/mysql80_v20260901.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/mysql80_v20260901.0_linux_arm64)           |
| mysqldump80  | [custom/mysql80](https://aur.archlinux.org/packages/mysql80)                                          | 8.0.45   | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/mysqldump80_v20260901.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/mysqldump80_v20260901.0_linux_arm64)   |
| mysql84      | [custom/mysql84](https://aur.archlinux.org/packages/mysql84)                                          | 8.4.10   | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/mysql84_v20260901.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/mysql84_v20260901.0_linux_arm64)           |
| mysqldump84  | [custom/mysql84](https://aur.archlinux.org/packages/mysql84)                                          | 8.4.10   | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/mysqldump84_v20260901.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20260901.0/mysqldump84_v20260901.0_linux_arm64)   |

## Tested Linux
| name         | arch    | kernel                       | libc       |
| ------------ | ------- | ---------------------------- | ---------- |
| Arch Linux   | x86_64  | 6.18.9-arch1-2               | glibc 2.43 |
| Debian 13    | x86_64  | 6.12.73+deb13-cloud-amd64    | glibc 2.41 |
| Debian 12    | x86_64  | 6.1.0-43-cloud-amd64         | glibc 2.36 |
| Debian 11    | x86_64  | 5.10.0-38-cloud-amd64        | glibc 2.31 |
| Ubuntu 24.04 | x86_64  | 6.8.0-101-generic            | glibc 2.39 |
| Ubuntu 22.04 | x86_64  | 5.15.0-171-generic           | glibc 2.35 |
| Ubuntu 20.04 | x86_64  | 5.4.0-216-generic            | glibc 2.31 |
| Ubuntu 18.04 | x86_64  | 4.15.0-212-generic           | glibc 2.27 |
| Alpine 3.23  | x86_64  | 6.18.7-0-virt                | musl 1.2.5 |
| Alpine 3.22  | x86_64  | 6.12.67-0-virt               | musl 1.2.5 |
| Alpine 3.21  | x86_64  | 6.12.67-0-virt               | musl 1.2.5 |
| CentOS 7     | x86_64  | 3.10.0-1160.80.1.el7.x86_64  | glibc 2.17 |
| Rocky 8.10   | x86_64  | 4.18.0-553.el8_10.x86_64     | glibc 2.28 |
| Rocky 9.7    | x86_64  | 5.14.0-611.5.1.el9_7.x86_64  | glibc 2.34 |
| Debian 13    | aarch64 | 6.12.73+deb13-cloud-arm64    | glibc 2.41 |
| Debian 12    | aarch64 | 6.1.0-43-cloud-arm64         | glibc 2.36 |
| Debian 11    | aarch64 | 5.10.0-38-cloud-arm64        | glibc 2.31 |
| Ubuntu 24.04 | aarch64 | 6.8.0-101-generic            | glibc 2.39 |
| Ubuntu 22.04 | aarch64 | 5.15.0-171-generic           | glibc 2.35 |
| Ubuntu 20.04 | aarch64 | 5.4.0-216-generic            | glibc 2.31 |
| Ubuntu 18.04 | aarch64 | 4.15.0-212-generic           | glibc 2.27 |
| Alpine 3.23  | aarch64 | 6.18.7-0-virt                | musl 1.2.5 |
| Alpine 3.22  | aarch64 | 6.12.67-0-virt               | musl 1.2.5 |
| Alpine 3.21  | aarch64 | 6.12.67-0-virt               | musl 1.2.5 |
| CentOS 7     | aarch64 | 4.18.0-348.20.1.el7.aarch64  | glibc 2.17 |
| Rocky 8.10   | aarch64 | 4.18.0-553.el8_10.aarch64    | glibc 2.28 |
| Rocky 9.7    | aarch64 | 5.14.0-611.5.1.el9_7.aarch64 | glibc 2.34 |

* name: `cat /etc/os-release`
* arch: `uname --machine`
* kernel: `uname --kernel-release`
* libc: `ldd --version`

## Build Release
```sh
# example: build static wget binary for current platform
docker build -o=dist main/wget

# example: build for another platform (not fully tested, use with caution)
docker build --platform linux/386 -o=dist main/wget     # build linux/386 on amd64 host
docker build --platform linux/arm/v7 -o=dist main/wget  # build linux/arm/v7 on arm64 host
```

## Development
```sh
# use docker as build environment
mkdir -p src-gitignore apk-gitignore archive-gitignore
docker run --rm -it \
  -v ./src-gitignore:/src \
  -v ./apk-gitignore:/var/cache/apk \
  -v ./archive-gitignore:/var/cache/distfiles \
  alpine:3.23 sh

# prepare development dependencies
ln -s /var/cache/apk /etc/apk/cache
apk upgrade && apk add alpine-sdk git nano
git clone https://github.com/whoisnian/static-binaries.git /src

# example: manually run htop build commands in the Dockerfile
cd /src/main/htop/aports
abuild -F deps
apk add ncurses-static
sed -i APKBUILD -e 's|./configure|./configure --enable-static|'
abuild -F fetch verify unpack prepare mkusers build package

./pkg/htop/usr/bin/htop --help
```

## Reference
* [Creating an Alpine package](https://wiki.alpinelinux.org/wiki/Creating_an_Alpine_package)
* [Alpine Linux aports repository](https://gitlab.alpinelinux.org/alpine/aports)
* [Arch build system repository](https://gitlab.archlinux.org/archlinux/packaging/packages)
* [Arch User Repository](https://aur.archlinux.org/packages)
* [Debian packaging repository](https://salsa.debian.org/debian)
* [Beyond Linux From Scratch Book](https://www.linuxfromscratch.org/blfs/view/stable-systemd/)
