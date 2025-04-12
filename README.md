# static-binaries
[![Release Status](https://github.com/whoisnian/static-binaries/actions/workflows/release.yml/badge.svg)](https://github.com/whoisnian/static-binaries/actions/workflows/release.yml)
[![Release Version](https://img.shields.io/github/v/release/whoisnian/static-binaries?label=version)](https://github.com/whoisnian/static-binaries/releases/latest)

Build static binaries based on Alpine Linux packages.

## Binaries
Last build: `2025-04-07T16:13:46Z` with Alpine Linux `v3.21`

| binary       | package                                                                                         | version   | download                                                                                                                                                                                                                                            |
| ------------ | ----------------------------------------------------------------------------------------------- | --------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| fio          | [community/fio](https://pkgs.alpinelinux.org/package/v3.21/community/x86_64/fio)                | 3.38      | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/fio_v20250408.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/fio_v20250408.0_linux_arm64)                   |
| redis-cli    | [community/redis](https://pkgs.alpinelinux.org/package/v3.21/community/x86_64/redis)            | 7.2.7     | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/redis-cli_v20250408.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/redis-cli_v20250408.0_linux_arm64)       |
| 7z           | [main/7zip](https://pkgs.alpinelinux.org/package/v3.21/main/x86_64/7zip)                        | 24.08     | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/7z_v20250408.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/7z_v20250408.0_linux_arm64)                     |
| curl         | [main/curl](https://pkgs.alpinelinux.org/package/v3.21/main/x86_64/curl)                        | 8.12.1    | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/curl_v20250408.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/curl_v20250408.0_linux_arm64)                 |
| htop         | [main/htop](https://pkgs.alpinelinux.org/package/v3.21/main/x86_64/htop)                        | 3.3.0     | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/htop_v20250408.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/htop_v20250408.0_linux_arm64)                 |
| iperf3       | [main/iperf3](https://pkgs.alpinelinux.org/package/v3.21/main/x86_64/iperf3)                    | 3.17.1    | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/iperf3_v20250408.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/iperf3_v20250408.0_linux_arm64)             |
| ss           | [main/iproute2](https://pkgs.alpinelinux.org/package/v3.21/main/x86_64/iproute2-ss)             | 6.11.0    | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/ss_v20250408.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/ss_v20250408.0_linux_arm64)                     |
| lsof         | [main/lsof](https://pkgs.alpinelinux.org/package/v3.21/main/x86_64/lsof)                        | 4.99.4    | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/lsof_v20250408.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/lsof_v20250408.0_linux_arm64)                 |
| mariadb      | [main/mariadb](https://pkgs.alpinelinux.org/package/v3.21/main/x86_64/mariadb-client)           | 11.4.5    | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/mariadb_v20250408.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/mariadb_v20250408.0_linux_arm64)           |
| mariadb-dump | [main/mariadb](https://pkgs.alpinelinux.org/package/v3.21/main/x86_64/mariadb-client)           | 11.4.5    | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/mariadb-dump_v20250408.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/mariadb-dump_v20250408.0_linux_arm64) |
| nano         | [main/nano](https://pkgs.alpinelinux.org/package/v3.21/main/x86_64/nano)                        | 8.2       | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/nano_v20250408.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/nano_v20250408.0_linux_arm64)                 |
| nc           | [main/netcat-openbsd](https://pkgs.alpinelinux.org/package/v3.21/main/x86_64/netcat-openbsd)    | 1.226-1.1 | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/nc_v20250408.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/nc_v20250408.0_linux_arm64)                     |
| nmap         | [main/nmap](https://pkgs.alpinelinux.org/package/v3.21/main/x86_64/nmap)                        | 7.95      | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/nmap_v20250408.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/nmap_v20250408.0_linux_arm64)                 |
| pigz         | [main/pigz](https://pkgs.alpinelinux.org/package/v3.21/main/x86_64/pigz)                        | 2.8       | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/pigz_v20250408.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/pigz_v20250408.0_linux_arm64)                 |
| psql         | [main/postgresql17](https://pkgs.alpinelinux.org/package/v3.21/main/x86_64/postgresql17-client) | 17.4      | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/psql_v20250408.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/psql_v20250408.0_linux_arm64)                 |
| pg_dump      | [main/postgresql17](https://pkgs.alpinelinux.org/package/v3.21/main/x86_64/postgresql17-client) | 17.4      | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/pg_dump_v20250408.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/pg_dump_v20250408.0_linux_arm64)           |
| ps           | [main/procps-ng](https://pkgs.alpinelinux.org/package/v3.21/main/x86_64/procps-ng)              | 4.0.4     | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/ps_v20250408.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/ps_v20250408.0_linux_arm64)                     |
| rsync        | [main/rsync](https://pkgs.alpinelinux.org/package/v3.21/main/x86_64/rsync)                      | 3.4.0     | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/rsync_v20250408.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/rsync_v20250408.0_linux_arm64)               |
| socat        | [main/socat](https://pkgs.alpinelinux.org/package/v3.21/main/x86_64/socat)                      | 1.8.0.1   | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/socat_v20250408.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/socat_v20250408.0_linux_arm64)               |
| strace       | [main/strace](https://pkgs.alpinelinux.org/package/v3.21/main/x86_64/strace)                    | 6.12      | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/strace_v20250408.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/strace_v20250408.0_linux_arm64)             |
| tcpdump      | [main/tcpdump](https://pkgs.alpinelinux.org/package/v3.21/main/x86_64/tcpdump)                  | 4.99.5    | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/tcpdump_v20250408.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/tcpdump_v20250408.0_linux_arm64)           |
| vim          | [main/vim](https://pkgs.alpinelinux.org/package/v3.21/main/x86_64/vim)                          | 9.1.1105  | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/vim_v20250408.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/vim_v20250408.0_linux_arm64)                   |
| xxd          | [main/vim](https://pkgs.alpinelinux.org/package/v3.21/main/x86_64/xxd)                          | 9.1.1105  | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/xxd_v20250408.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/xxd_v20250408.0_linux_arm64)                   |
| wget         | [main/wget](https://pkgs.alpinelinux.org/package/v3.21/main/x86_64/wget)                        | 1.25.0    | [amd64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/wget_v20250408.0_linux_amd64) / [arm64](https://github.com/whoisnian/static-binaries/releases/download/v20250408.0/wget_v20250408.0_linux_arm64)                 |

## Tested Linux
| name         | arch    | kernel                      | libc       |
| ------------ | ------- | --------------------------- | ---------- |
| Arch Linux   | x86_64  | 6.14.2-arch1-1              | glibc 2.41 |
| Debian 12    | x86_64  | 6.1.0-32-cloud-amd64        | glibc 2.36 |
| Debian 11    | x86_64  | 5.10.0-34-cloud-amd64       | glibc 2.31 |
| Ubuntu 24.04 | x86_64  | 6.8.0-57-generic            | glibc 2.39 |
| Ubuntu 22.04 | x86_64  | 5.15.0-135-generic          | glibc 2.35 |
| Ubuntu 20.04 | x86_64  | 5.4.0-212-generic           | glibc 2.31 |
| Ubuntu 18.04 | x86_64  | 4.15.0-212-generic          | glibc 2.27 |
| Alpine 3.21  | x86_64  | 6.12.8-0-virt               | musl 1.2.5 |
| CentOS 7     | x86_64  | 3.10.0-1160.80.1.el7.x86_64 | glibc 2.17 |
| Rocky 8.10   | x86_64  | 4.18.0-553.el8_10.x86_64    | glibc 2.28 |
| Debian 12    | aarch64 | 6.1.0-32-cloud-arm64        | glibc 2.36 |
| Debian 11    | aarch64 | 5.10.0-34-cloud-arm64       | glibc 2.31 |
| Ubuntu 24.04 | aarch64 | 6.8.0-57-generic            | glibc 2.39 |
| Ubuntu 22.04 | aarch64 | 5.15.0-135-generic          | glibc 2.35 |
| Ubuntu 20.04 | aarch64 | 5.4.0-212-generic           | glibc 2.31 |
| Ubuntu 18.04 | aarch64 | 4.15.0-212-generic          | glibc 2.27 |
| Alpine 3.21  | aarch64 | 6.12.8-0-virt               | musl 1.2.5 |
| CentOS 7     | aarch64 | 4.18.0-348.20.1.el7.aarch64 | glibc 2.17 |
| Rocky 8.10   | aarch64 | 4.18.0-553.el8_10.aarch64   | glibc 2.28 |

* name: `cat /etc/os-release`
* arch: `uname --machine`
* kernel: `uname --kernel-release`
* libc: `ldd --version`

## Reference
* [Creating an Alpine package](https://wiki.alpinelinux.org/wiki/Creating_an_Alpine_package)
* [Alpine Linux aports repository](https://gitlab.alpinelinux.org/alpine/aports)
* [Arch build system repository](https://gitlab.archlinux.org/archlinux/packaging/packages)
* [Debian packaging repository](https://salsa.debian.org/debian)
* [Beyond Linux From Scratch Book](https://www.linuxfromscratch.org/blfs/view/stable-systemd/)
