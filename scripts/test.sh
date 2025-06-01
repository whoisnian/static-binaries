#!/bin/bash
#########################################################################
# File Name: test.sh
# Author: nian
# Blog: https://whoisnian.com
# Mail: zhuchangbao1998@gmail.com
# Created Time: Sat 05 Apr 2025 11:58:09 PM CST
#########################################################################

########## environment variables ##########
ENABLE_DEBUG=0
_BIN_SUFFIX='_v20250601.3_linux_amd64'
REDIS_CONN_OPTS=''    # '-u redis://testpw@127.0.0.1:6379'
MYSQL_CONN_OPTS=''    # '-h 127.0.0.1 -u root -ptestpw'
POSTGRES_CONN_OPTS='' # 'postgresql://postgres:testpw@127.0.0.1/postgres'
TEMP_HTTP_PORT=18080
TEMP_IPERF3_PORT=$(($TEMP_HTTP_PORT + 1))
TEMP_SOCAT_PORT=$(($TEMP_HTTP_PORT + 2))

########## common functions ##########
function log_i() { echo -e "$(date +'%Y%m%d %H:%M:%S') \033[32m[I] $1\033[0m"; }
function log_w() { echo -e "$(date +'%Y%m%d %H:%M:%S') \033[33m[W] $1\033[0m"; }
function log_e() { echo -e "$(date +'%Y%m%d %H:%M:%S') \033[31m[E] $1\033[0m"; }
function log_f() { echo -e "$(date +'%Y%m%d %H:%M:%S') \033[31m[F] $1\033[0m" && exit 1; }
function assert_grep() { if ! grep -q "$1" <<<"$2"; then log_f "grep '$1' failed"; fi; }
function assert_grep_E() { if ! grep -q -E "$1" <<<"$2"; then log_f "grep '$1' failed"; fi; }
function one_time_httpd() {
  echo -e 'HTTP/1.1 200 OK\ncontent-length: 15\n\none_time_httpd\n' | ./dist/"nc${_BIN_SUFFIX}" -N -l -p $TEMP_HTTP_PORT >/dev/null &
  sleep 0.5
}

[ $ENABLE_DEBUG -eq 1 ] && set -x

########## sidecar containers ##########
START_REDIS_DOCKER=0
if [ -z "$REDIS_CONN_OPTS" ]; then
  START_REDIS_DOCKER=1
  REDIS_CONN_OPTS='-u redis://testpw@127.0.0.1:6379'
  REDIS_CONTAINER_ID=$(sudo docker inspect -f '{{.ID}}' redis-sidecar 2>/dev/null)
  if [ -z "$REDIS_CONTAINER_ID" ]; then
    REDIS_CONTAINER_ID=$(sudo docker run --rm -d --name redis-sidecar -p 6379:6379 redis:8.0.2-alpine --requirepass testpw)
    for i in {1..10}; do
      if sudo docker exec "$REDIS_CONTAINER_ID" redis-cli $REDIS_CONN_OPTS ping | grep -q 'PONG'; then
        break
      fi
      log_w "redis container not started, retry $i"
      sleep 2
    done
    if [ "$i" -ge 10 ]; then log_f 'redis container failed to start'; fi
  fi
fi

START_MYSQL_DOCKER=0
if [ -z "$MYSQL_CONN_OPTS" ]; then
  START_MYSQL_DOCKER=1
  MYSQL_CONN_OPTS='-h 127.0.0.1 -u root -ptestpw'
  MYSQL_CONTAINER_ID=$(sudo docker inspect -f '{{.ID}}' mysql-sidecar 2>/dev/null)
  if [ -z "$MYSQL_CONTAINER_ID" ]; then
    MYSQL_CONTAINER_ID=$(sudo docker run --rm -d --name mysql-sidecar -p 3306:3306 -e MYSQL_ROOT_PASSWORD=testpw mysql:8.0.42)
    for i in {1..10}; do
      if sudo docker exec "$MYSQL_CONTAINER_ID" mysqladmin -h localhost -u root -ptestpw ping 2>&1 | grep -q 'mysqld is alive'; then
        break
      fi
      log_w "mysql container not started, retry $i"
      sleep 4
    done
    if [ "$i" -ge 10 ]; then log_f 'mysql container failed to start'; fi
  fi
fi

START_POSTGRES_DOCKER=0
if [ -z "$POSTGRES_CONN_OPTS" ]; then
  START_POSTGRES_DOCKER=1
  POSTGRES_CONN_OPTS='postgresql://postgres:testpw@127.0.0.1/postgres'
  POSTGRES_CONTAINER_ID=$(sudo docker inspect -f '{{.ID}}' postgres-sidecar 2>/dev/null)
  if [ -z "$POSTGRES_CONTAINER_ID" ]; then
    POSTGRES_CONTAINER_ID=$(sudo docker run --rm -d --name postgres-sidecar -p 5432:5432 -e POSTGRES_PASSWORD=testpw postgres:17.5-alpine)
    for i in {1..10}; do
      if sudo docker exec "$POSTGRES_CONTAINER_ID" pg_isready | grep -q 'accepting connections'; then
        break
      fi
      log_w "postgres container not started, retry $i"
      sleep 2
    done
    if [ "$i" -ge 10 ]; then log_f 'postgres container failed to start'; fi
  fi
fi

########## test community/fio ##########
log_i 'test community/fio'

OUTPUT=$(./dist/"fio${_BIN_SUFFIX}" --version)
assert_grep 'fio-3.39' "$OUTPUT"

OUTPUT=$(./dist/"fio${_BIN_SUFFIX}" --name=fio_test --filename=temp_test_fio.data \
  --size=10MB --bs=4k --direct=1 --rw=randrw --ioengine=libaio \
  --iodepth=64 --runtime=1s --time_based --group_reporting)
rm -f temp_test_fio.data
assert_grep_E 'read: IOPS=[^,]+, BW=[^ ]+' "$OUTPUT"
assert_grep_E 'write: IOPS=[^,]+, BW=[^ ]+' "$OUTPUT"
assert_grep_E 'READ: bw=.+, io=.+, run=.+' "$OUTPUT"
assert_grep_E 'WRITE: bw=.+, io=.+, run=.+' "$OUTPUT"

log_i 'test community/fio success'

########## test community/redis ##########
log_i 'test community/redis'

OUTPUT=$(./dist/"redis-cli${_BIN_SUFFIX}" --version)
assert_grep 'redis-cli 8.0.2' "$OUTPUT"

OUTPUT=$(./dist/"redis-cli${_BIN_SUFFIX}" $REDIS_CONN_OPTS set tkey tvalue)
assert_grep 'OK' "$OUTPUT"
OUTPUT=$(./dist/"redis-cli${_BIN_SUFFIX}" $REDIS_CONN_OPTS get tkey)
assert_grep 'tvalue' "$OUTPUT"

log_i 'test community/redis success'

########## test main/7zip ##########
log_i 'test main/7zip'

OUTPUT=$(./dist/"7z${_BIN_SUFFIX}" --help)
assert_grep '7-Zip (z) 24.09' "$OUTPUT"

echo 'test_7zip' >temp_test_7zip.txt
OUTPUT=$(./dist/"7z${_BIN_SUFFIX}" a temp_test_7zip.7z temp_test_7zip.txt)
assert_grep 'Everything is Ok' "$OUTPUT"
OUTPUT=$(./dist/"7z${_BIN_SUFFIX}" l temp_test_7zip.7z)
assert_grep 'temp_test_7zip.txt' "$OUTPUT"
rm -f temp_test_7zip.txt
OUTPUT=$(./dist/"7z${_BIN_SUFFIX}" x temp_test_7zip.7z)
assert_grep 'Everything is Ok' "$OUTPUT"
assert_grep 'test_7zip' "$(cat temp_test_7zip.txt)"

rm -f temp_test_7zip.txt temp_test_7zip.7z
log_i 'test main/7zip success'

########## test main/curl ##########
log_i 'test main/curl'

OUTPUT=$(./dist/"curl${_BIN_SUFFIX}" --version)
assert_grep 'curl 8.14.0' "$OUTPUT"

one_time_httpd
OUTPUT=$(./dist/"curl${_BIN_SUFFIX}" --silent "http://127.0.0.1:$TEMP_HTTP_PORT")
assert_grep 'one_time_httpd' "$OUTPUT"

log_i 'test main/curl success'

########## test main/htop ##########
log_i 'test main/htop'

OUTPUT=$(./dist/"htop${_BIN_SUFFIX}" --version)
assert_grep 'htop 3.4.1' "$OUTPUT"

OUTPUT=$(echo q | ./dist/"htop${_BIN_SUFFIX}" --no-color)
assert_grep 'Load average' "$OUTPUT"

log_i 'test main/htop success'

########## test main/iperf3 ##########
log_i 'test main/iperf3'

OUTPUT=$(./dist/"iperf3${_BIN_SUFFIX}" --version)
assert_grep 'iperf 3.19' "$OUTPUT"

./dist/"iperf3${_BIN_SUFFIX}" --server --port $TEMP_IPERF3_PORT --daemon --one-off
sleep 0.5
OUTPUT=$(./dist/"iperf3${_BIN_SUFFIX}" --client 127.0.0.1 --port $TEMP_IPERF3_PORT --time 1)
assert_grep 'iperf Done' "$OUTPUT"

log_i 'test main/iperf3 success'

########## test main/iproute2 ##########
log_i 'test main/iproute2'

OUTPUT=$(./dist/"ss${_BIN_SUFFIX}" --version)
assert_grep 'ss utility, iproute2-6.15.0' "$OUTPUT"

OUTPUT=$(./dist/"ss${_BIN_SUFFIX}" --tcp --listening --numeric --processes)
assert_grep 'Local Address:Port' "$OUTPUT"

log_i 'test main/iproute2 success'

########## test main/lsof ##########
log_i 'test main/lsof'

OUTPUT=$(./dist/"lsof${_BIN_SUFFIX}" -v 2>&1)
assert_grep 'revision: 4.99.4' "$OUTPUT"

OUTPUT=$(./dist/"lsof${_BIN_SUFFIX}" -p "$$")
assert_grep 'test.sh' "$OUTPUT"

log_i 'test main/lsof success'

########## test main/mariadb ##########
log_i 'test main/mariadb'

OUTPUT=$(./dist/"mariadb${_BIN_SUFFIX}" --version)
assert_grep 'from 11.4.5-MariaDB' "$OUTPUT"
OUTPUT=$(./dist/"mariadb-dump${_BIN_SUFFIX}" --version)
assert_grep 'from 11.4.5-MariaDB' "$OUTPUT"

OUTPUT=$(./dist/"mariadb${_BIN_SUFFIX}" $MYSQL_CONN_OPTS --disable-ssl-verify-server-cert -e 'select User from mysql.user')
assert_grep 'mysql.infoschema' "$OUTPUT"
OUTPUT=$(./dist/"mariadb-dump${_BIN_SUFFIX}" $MYSQL_CONN_OPTS --disable-ssl-verify-server-cert mysql user)
assert_grep 'Table structure for table' "$OUTPUT"
assert_grep 'Dumping data for table' "$OUTPUT"
assert_grep 'INSERT INTO `user` VALUES' "$OUTPUT"
assert_grep 'Dump completed on' "$OUTPUT"

log_i 'test main/mariadb success'

########## test main/nano ##########
log_i 'test main/nano'

OUTPUT=$(./dist/"nano${_BIN_SUFFIX}" --version)
assert_grep 'GNU nano, version 8.4' "$OUTPUT"

echo -e 'Press Ctrl+K then Ctrl+X.\nthis line will be deleted\nthis line will be kept' >temp_test_nano.txt
./dist/"nano${_BIN_SUFFIX}" --ignorercfiles --saveonexit +2 temp_test_nano.txt
assert_grep 'will be kept' "$(cat temp_test_nano.txt)"
if grep -q 'will be deleted' temp_test_nano.txt; then log_f 'nano failed to delete second line'; fi

rm -f temp_test_nano.txt
log_i 'test main/nano success'

########## test main/netcat-openbsd ##########
log_i 'test main/netcat-openbsd'

OUTPUT=$(./dist/"nc${_BIN_SUFFIX}" -h 2>&1)
assert_grep 'OpenBSD netcat (Debian patchlevel 1.229-1)' "$OUTPUT"

./dist/"nc${_BIN_SUFFIX}" -N -l $TEMP_HTTP_PORT <<<'successful_response' >/dev/null &
sleep 0.5
OUTPUT=$(./dist/"nc${_BIN_SUFFIX}" -N 127.0.0.1 $TEMP_HTTP_PORT <<<'request')
assert_grep 'successful_response' "$OUTPUT"

log_i 'test main/netcat-openbsd success'

########## test main/nmap ##########
log_i 'test main/nmap'

OUTPUT=$(./dist/"nmap${_BIN_SUFFIX}" -V)
assert_grep 'Nmap version 7.97' "$OUTPUT"

OUTPUT=$(./dist/"nmap${_BIN_SUFFIX}" 127.0.0.1)
assert_grep 'Nmap done: 1 IP address (1 host up) scanned' "$OUTPUT"

log_i 'test main/nmap success'

########## test main/pigz ##########
log_i 'test main/pigz'

OUTPUT=$(./dist/"pigz${_BIN_SUFFIX}" --version)
assert_grep 'pigz 2.8' "$OUTPUT"

OUTPUT=$(echo 'pigz_test_compress' | ./dist/"pigz${_BIN_SUFFIX}" | gzip -d)
assert_grep 'pigz_test_compress' "$OUTPUT"
OUTPUT=$(echo 'pigz_test_decompress' | gzip | ./dist/"pigz${_BIN_SUFFIX}" -d)
assert_grep 'pigz_test_decompress' "$OUTPUT"

log_i 'test main/pigz success'

########## test main/postgresql17 ##########
log_i 'test main/postgresql17'

OUTPUT=$(./dist/"psql${_BIN_SUFFIX}" --version)
assert_grep 'psql (PostgreSQL) 17.5' "$OUTPUT"
OUTPUT=$(./dist/"pg_dump${_BIN_SUFFIX}" --version)
assert_grep 'pg_dump (PostgreSQL) 17.5' "$OUTPUT"

OUTPUT=$(./dist/"psql${_BIN_SUFFIX}" $POSTGRES_CONN_OPTS -c "select table_name from information_schema.tables where table_schema='information_schema'")
assert_grep 'information_schema_catalog_name' "$OUTPUT"
OUTPUT=$(./dist/"pg_dump${_BIN_SUFFIX}" $POSTGRES_CONN_OPTS)
assert_grep 'PostgreSQL database dump complete' "$OUTPUT"

log_i 'test main/postgresql17 success'

########## test main/procps-ng ##########
log_i 'test main/procps-ng'

OUTPUT=$(./dist/"ps${_BIN_SUFFIX}" --version)
assert_grep 'procps-ng 4.0.4' "$OUTPUT"

OUTPUT=$(./dist/"ps${_BIN_SUFFIX}" aux)
assert_grep 'test.sh' "$OUTPUT"

log_i 'test main/procps-ng success'

########## test main/rsync ##########
log_i 'test main/rsync'

OUTPUT=$(./dist/"rsync${_BIN_SUFFIX}" --version)
assert_grep 'version 3.4.1' "$OUTPUT"

echo 'rsync_test' >temp_test_rsync_from.txt
OUTPUT=$(./dist/"rsync${_BIN_SUFFIX}" -avz temp_test_rsync_from.txt temp_test_rsync_to.txt)
assert_grep_E 'total size is .* speedup is ' "$OUTPUT"
assert_grep 'rsync_test' "$(cat temp_test_rsync_to.txt)"

rm -f temp_test_rsync_from.txt temp_test_rsync_to.txt
log_i 'test main/rsync success'

########## test main/socat ##########
log_i 'test main/socat'

OUTPUT=$(./dist/"socat${_BIN_SUFFIX}" -V)
assert_grep 'socat version 1.8.0.3' "$OUTPUT"

one_time_httpd
./dist/"socat${_BIN_SUFFIX}" "TCP-LISTEN:$TEMP_SOCAT_PORT" "TCP4:127.0.0.1:$TEMP_HTTP_PORT" &
sleep 0.5
OUTPUT=$(./dist/"curl${_BIN_SUFFIX}" --silent "http://127.0.0.1:$TEMP_SOCAT_PORT")
assert_grep 'one_time_httpd' "$OUTPUT"

log_i 'test main/socat success'

########## test main/strace ##########
log_i 'test main/strace'

OUTPUT=$(./dist/"strace${_BIN_SUFFIX}" --version)
assert_grep 'strace -- version 6.13' "$OUTPUT"

OUTPUT=$(./dist/"strace${_BIN_SUFFIX}" -o temp_test_strace.txt cat /dev/null)
OUTPUT=$(cat temp_test_strace.txt)
assert_grep_E '^open' "$OUTPUT"
assert_grep_E '^read' "$OUTPUT"
assert_grep_E '^close' "$OUTPUT"

rm -f temp_test_strace.txt
log_i 'test main/strace success'

########## test main/tcpdump ##########
log_i 'test main/tcpdump'

OUTPUT=$(./dist/"tcpdump${_BIN_SUFFIX}" --version)
assert_grep 'version 4.99.5' "$OUTPUT"

one_time_httpd
sudo ./dist/"tcpdump${_BIN_SUFFIX}" --interface lo -A -n -c 4 "tcp src port $TEMP_HTTP_PORT" 2>/dev/null 1>temp_test_tcpdump.data &
sleep 1
OUTPUT=$(./dist/"curl${_BIN_SUFFIX}" --silent "http://127.0.0.1:$TEMP_HTTP_PORT")
sleep 1
assert_grep 'one_time_httpd' "$OUTPUT"
assert_grep 'one_time_httpd' "$(cat temp_test_tcpdump.data)"

rm -f temp_test_tcpdump.data
log_i 'test main/tcpdump success'

########## test main/vim ##########
log_i 'test main/vim'

OUTPUT=$(./dist/"vim${_BIN_SUFFIX}" --version)
assert_grep 'VIM - Vi IMproved 9.1' "$OUTPUT"

echo 'test_vim' >temp_test_vim.txt
OUTPUT=$(./dist/"vim${_BIN_SUFFIX}" --not-a-term -u NONE -N +'%s/test/test_s/g' +'wq' temp_test_vim.txt)
assert_grep 'test_s_vim' "$(cat temp_test_vim.txt)"
OUTPUT=$(./dist/"xxd${_BIN_SUFFIX}" -ps temp_test_vim.txt)
assert_grep '746573745f735f76696d0a' "$OUTPUT"

rm -f temp_test_vim.txt
log_i 'test main/vim success'

########## test main/wget ##########
log_i 'test main/wget'

OUTPUT=$(./dist/"wget${_BIN_SUFFIX}" --version)
assert_grep 'GNU Wget 1.25.0' "$OUTPUT"

one_time_httpd
OUTPUT=$(./dist/"wget${_BIN_SUFFIX}" --quiet -O - "http://127.0.0.1:$TEMP_HTTP_PORT")
assert_grep 'one_time_httpd' "$OUTPUT"

log_i 'test main/wget success'

########## test custom/mysql57 ##########
log_i 'test custom/mysql57'

OUTPUT=$(./dist/"mysql57${_BIN_SUFFIX}" --version)
assert_grep 'Distrib 5.7.44' "$OUTPUT"
OUTPUT=$(./dist/"mysqldump57${_BIN_SUFFIX}" --version)
assert_grep 'Distrib 5.7.44' "$OUTPUT"

OUTPUT=$(./dist/"mysql57${_BIN_SUFFIX}" $MYSQL_CONN_OPTS -e 'select User from mysql.user')
assert_grep 'mysql.infoschema' "$OUTPUT"
OUTPUT=$(./dist/"mysqldump57${_BIN_SUFFIX}" $MYSQL_CONN_OPTS mysql user)
assert_grep 'Table structure for table' "$OUTPUT"
assert_grep 'Dumping data for table' "$OUTPUT"
assert_grep 'INSERT INTO `user` VALUES' "$OUTPUT"
assert_grep 'Dump completed on' "$OUTPUT"

log_i 'test custom/mysql57 success'

########## test custom/mysql80 ##########
log_i 'test custom/mysql80'

OUTPUT=$(./dist/"mysql80${_BIN_SUFFIX}" --version)
assert_grep 'Ver 8.0.42' "$OUTPUT"
OUTPUT=$(./dist/"mysqldump80${_BIN_SUFFIX}" --version)
assert_grep 'Ver 8.0.42' "$OUTPUT"

OUTPUT=$(./dist/"mysql80${_BIN_SUFFIX}" $MYSQL_CONN_OPTS -e 'select User from mysql.user')
assert_grep 'mysql.infoschema' "$OUTPUT"
OUTPUT=$(./dist/"mysqldump80${_BIN_SUFFIX}" $MYSQL_CONN_OPTS mysql user)
assert_grep 'Table structure for table' "$OUTPUT"
assert_grep 'Dumping data for table' "$OUTPUT"
assert_grep 'INSERT INTO `user` VALUES' "$OUTPUT"
assert_grep 'Dump completed on' "$OUTPUT"

log_i 'test custom/mysql80 success'

########## test custom/mysql84 ##########
log_i 'test custom/mysql84'

OUTPUT=$(./dist/"mysql84${_BIN_SUFFIX}" --version)
assert_grep 'Ver 8.4.5' "$OUTPUT"
OUTPUT=$(./dist/"mysqldump84${_BIN_SUFFIX}" --version)
assert_grep 'Ver 8.4.5' "$OUTPUT"

OUTPUT=$(./dist/"mysql84${_BIN_SUFFIX}" $MYSQL_CONN_OPTS -e 'select User from mysql.user')
assert_grep 'mysql.infoschema' "$OUTPUT"
OUTPUT=$(./dist/"mysqldump84${_BIN_SUFFIX}" $MYSQL_CONN_OPTS mysql user)
assert_grep 'Table structure for table' "$OUTPUT"
assert_grep 'Dumping data for table' "$OUTPUT"
assert_grep 'INSERT INTO `user` VALUES' "$OUTPUT"
assert_grep 'Dump completed on' "$OUTPUT"

log_i 'test custom/mysql84 success'

########## ########## ##########
[ $START_REDIS_DOCKER -eq 1 ] && sudo docker stop "$REDIS_CONTAINER_ID" >/dev/null
[ $START_MYSQL_DOCKER -eq 1 ] && sudo docker stop "$MYSQL_CONTAINER_ID" >/dev/null
[ $START_POSTGRES_DOCKER -eq 1 ] && sudo docker stop "$POSTGRES_CONTAINER_ID" >/dev/null

log_i 'all tests success'
