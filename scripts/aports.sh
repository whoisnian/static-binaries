#!/bin/bash
#########################################################################
# File Name: aports.sh
# Author: nian
# Blog: https://whoisnian.com
# Mail: zhuchangbao1998@gmail.com
# Created Time: Sat 31 May 2025 02:11:53 AM CST
#########################################################################

########## environment variables ##########
ENABLE_DEBUG=0
ALPINE_VERSION="3.22"
SCRIPT_DIR=$(dirname "$0")
SOURCE_DIR="$SCRIPT_DIR/.."

########## common functions ##########
function log_i() { echo -e "$(date +'%Y%m%d %H:%M:%S') \033[32m[I] $1\033[0m"; }
function log_w() { echo -e "$(date +'%Y%m%d %H:%M:%S') \033[33m[W] $1\033[0m"; }
function log_e() { echo -e "$(date +'%Y%m%d %H:%M:%S') \033[31m[E] $1\033[0m"; }
function log_f() { echo -e "$(date +'%Y%m%d %H:%M:%S') \033[31m[F] $1\033[0m" && exit 1; }
function reset_and_pull_as_aports() {
  log_i "reset and pull aports for $1"
  rm -rf "$SOURCE_DIR/$1/aports" && mkdir -p "$SOURCE_DIR/$1/aports"
  curl "https://gitlab.alpinelinux.org/alpine/aports/-/archive/${ALPINE_VERSION}-stable/aports-${ALPINE_VERSION}-stable.tar.gz?path=$1" | \
    tar -xzf - --strip-components=3 --directory "$SOURCE_DIR/$1/aports"
}
function reset_and_pull_extra_for() {
  log_i "reset and pull extra $2 for $1"
  rm -rf "$SOURCE_DIR/$1/$(basename $2)" && mkdir -p "$SOURCE_DIR/$1/$(basename $2)"
  curl "https://gitlab.alpinelinux.org/alpine/aports/-/archive/${ALPINE_VERSION}-stable/aports-${ALPINE_VERSION}-stable.tar.gz?path=$2" | \
    tar -xzf - --strip-components=3 --directory "$SOURCE_DIR/$1/$(basename $2)"
}

[ $ENABLE_DEBUG -eq 1 ] && set -x

reset_and_pull_as_aports community/fio
reset_and_pull_as_aports community/redis
reset_and_pull_as_aports main/7zip
reset_and_pull_as_aports main/curl
reset_and_pull_as_aports main/htop
reset_and_pull_as_aports main/iperf3
reset_and_pull_as_aports main/iproute2
reset_and_pull_as_aports main/lsof
reset_and_pull_as_aports main/mariadb
reset_and_pull_as_aports main/nano
reset_and_pull_as_aports main/netcat-openbsd
reset_and_pull_as_aports main/nmap
reset_and_pull_as_aports main/pigz
reset_and_pull_as_aports main/postgresql17
reset_and_pull_as_aports main/procps-ng
reset_and_pull_as_aports main/rsync
reset_and_pull_extra_for main/rsync main/xxhash
reset_and_pull_as_aports main/socat
reset_and_pull_as_aports main/strace
reset_and_pull_as_aports main/tcpdump
reset_and_pull_as_aports main/vim
reset_and_pull_as_aports main/wget
