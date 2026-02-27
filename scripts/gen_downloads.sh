#!/bin/bash
#########################################################################
# File Name: gen_downloads.sh
# Author: nian
# Blog: https://whoisnian.com
# Mail: zhuchangbao1998@gmail.com
# Created Time: Sat 27 Feb 2026 23:53:15 PM CST
#########################################################################

########## environment variables ##########
ALPINE_VERSION="3.23"
SCRIPT_DIR=$(dirname "$0")
SOURCE_DIR="$SCRIPT_DIR/.."

TAG="${1:-}"
[ -z "$TAG" ] && echo "Usage: $0 <tag>" && exit 1

########## upstream info ##########
# format: binary_name|directory|upstream_url
declare -a BINARIES=(
  "fio|community/fio|https://pkgs.alpinelinux.org/package/edge/community/x86_64/fio"
  "qrencode|community/libqrencode|https://pkgs.alpinelinux.org/package/edge/community/x86_64/libqrencode-tools"
  "redis-cli|community/redis|https://pkgs.alpinelinux.org/package/edge/community/x86_64/redis"
  "7z|main/7zip|https://pkgs.alpinelinux.org/package/edge/main/x86_64/7zip"
  "curl|main/curl|https://pkgs.alpinelinux.org/package/edge/main/x86_64/curl"
  "htop|main/htop|https://pkgs.alpinelinux.org/package/edge/main/x86_64/htop"
  "iperf3|main/iperf3|https://pkgs.alpinelinux.org/package/edge/main/x86_64/iperf3"
  "ss|main/iproute2|https://pkgs.alpinelinux.org/package/edge/main/x86_64/iproute2-ss"
  "lsof|main/lsof|https://pkgs.alpinelinux.org/package/edge/main/x86_64/lsof"
  "mariadb|main/mariadb|https://pkgs.alpinelinux.org/package/edge/main/x86_64/mariadb-client"
  "mariadb-dump|main/mariadb|https://pkgs.alpinelinux.org/package/edge/main/x86_64/mariadb-client"
  "nano|main/nano|https://pkgs.alpinelinux.org/package/edge/main/x86_64/nano"
  "nc|main/netcat-openbsd|https://pkgs.alpinelinux.org/package/edge/main/x86_64/netcat-openbsd"
  "nmap|main/nmap|https://pkgs.alpinelinux.org/package/edge/main/x86_64/nmap"
  "pigz|main/pigz|https://pkgs.alpinelinux.org/package/edge/main/x86_64/pigz"
  "psql|main/postgresql17|https://pkgs.alpinelinux.org/package/edge/main/x86_64/postgresql17-client"
  "pg_dump|main/postgresql17|https://pkgs.alpinelinux.org/package/edge/main/x86_64/postgresql17-client"
  "ps|main/procps-ng|https://pkgs.alpinelinux.org/package/edge/main/x86_64/procps-ng"
  "rsync|main/rsync|https://pkgs.alpinelinux.org/package/edge/main/x86_64/rsync"
  "socat|main/socat|https://pkgs.alpinelinux.org/package/edge/main/x86_64/socat"
  "strace|main/strace|https://pkgs.alpinelinux.org/package/edge/main/x86_64/strace"
  "tcpdump|main/tcpdump|https://pkgs.alpinelinux.org/package/edge/main/x86_64/tcpdump"
  "vim|main/vim|https://pkgs.alpinelinux.org/package/edge/main/x86_64/vim"
  "xxd|main/vim|https://pkgs.alpinelinux.org/package/edge/main/x86_64/xxd"
  "wget|main/wget|https://pkgs.alpinelinux.org/package/edge/main/x86_64/wget"
  "mysql80|custom/mysql80|https://aur.archlinux.org/packages/mysql80"
  "mysqldump80|custom/mysql80|https://aur.archlinux.org/packages/mysql80"
  "mysql84|custom/mysql84|https://aur.archlinux.org/packages/mysql84"
  "mysqldump84|custom/mysql84|https://aur.archlinux.org/packages/mysql84"
)

########## main ##########
echo "Last build: \`$(date --utc +%FT%TZ)\` with Alpine Linux \`v$ALPINE_VERSION\`\n"
echo "| binary | package | version | download |"
echo "| ------ | ------- | ------- | -------- |"

for entry in "${BINARIES[@]}"; do
  IFS='|' read -r binary_name directory upstream_url <<< "$entry"

  package_version=$(grep -Po "(?<=ARG PACKAGE_VERSION=).*" "$SOURCE_DIR/$directory/Dockerfile" 2>/dev/null)
  package_link="[$directory]($upstream_url)"
  amd64_download_link="[amd64](https://github.com/whoisnian/static-binaries/releases/download/${TAG}/${binary_name}_${TAG}_linux_amd64)"
  arm64_download_link="[arm64](https://github.com/whoisnian/static-binaries/releases/download/${TAG}/${binary_name}_${TAG}_linux_arm64)"

  echo "| $binary_name | $package_link | $package_version | $amd64_download_link / $arm64_download_link |"
done
