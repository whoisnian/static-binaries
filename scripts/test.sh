#!/bin/bash
#########################################################################
# File Name: test.sh
# Author: nian
# Blog: https://whoisnian.com
# Mail: zhuchangbao1998@gmail.com
# Created Time: Sat 05 Apr 2025 11:58:09 PM CST
#########################################################################
set -e

########## environment variables ##########
SUFFIX='_v20250408.0_linux_amd64' # '_v20250408.0_linux_arm64'
REDIS_CONN_OPTS='' # '-u redis://testpw@127.0.0.1:6379'
MYSQL_CONN_OPTS='' # '-h 127.0.0.1 -u root -ptestpw --skip-ssl'
POSTGRES_CONN_OPTS='' # 'postgresql://postgres:testpw@127.0.0.1/postgres'
EPHEMERAL_HTTP_PORT=18080

########## common functions ##########
function log_i() { echo -e "$(date +'%Y%m%d %H:%M:%S') \033[32m[I] $1\033[0m"; }
function log_w() { echo -e "$(date +'%Y%m%d %H:%M:%S') \033[33m[W] $1\033[0m"; }
function log_e() { echo -e "$(date +'%Y%m%d %H:%M:%S') \033[31m[E] $1\033[0m"; }
function log_f() { echo -e "$(date +'%Y%m%d %H:%M:%S') \033[31m[F] $1\033[0m" && exit 1; }
function one_time_httpd() { echo -e 'HTTP/1.1 200 OK\ncontent-length: 15\n\none_time_httpd\n' | ./dist/"nc${SUFFIX}" -N -l -p $EPHEMERAL_HTTP_PORT >/dev/null & }

USE_REDIS_DOCKER=0
if [ -z "$REDIS_CONN_OPTS" ]; then
  USE_REDIS_DOCKER=1
  REDIS_CONN_OPTS='-u redis://testpw@127.0.0.1:6379'
fi
USE_MYSQL_DOCKER=0
if [ -z "$MYSQL_CONN_OPTS" ]; then
  USE_MYSQL_DOCKER=1
  MYSQL_CONN_OPTS='-h 127.0.0.1 -u root -ptestpw --skip-ssl'
fi
USE_POSTGRES_DOCKER=0
if [ -z "$POSTGRES_CONN_OPTS" ]; then
  USE_POSTGRES_DOCKER=1
  POSTGRES_CONN_OPTS='postgresql://postgres:testpw@127.0.0.1/postgres'
fi

########## test community/fio ##########
log_i 'start test community/fio'

OUTPUT=$(./dist/"fio${SUFFIX}" --version)
grep -q 'fio-3.38' <<<$OUTPUT

OUTPUT=$(./dist/"fio${SUFFIX}" --name=fio_test --filename=fio_test.data \
  --size=10MB --bs=4k --direct=1 --rw=randrw --ioengine=libaio \
  --iodepth=64 --runtime=1s --time_based --group_reporting)
rm -f fio_test.data
grep -q -E 'read: IOPS=[^,]+, BW=[^ ]+' <<<$OUTPUT
grep -q -E 'write: IOPS=[^,]+, BW=[^ ]+' <<<$OUTPUT
grep -q -E 'READ: bw=.+, io=.+, run=.+' <<<$OUTPUT
grep -q -E 'WRITE: bw=.+, io=.+, run=.+' <<<$OUTPUT

log_i 'test community/fio success'

########## test community/redis ##########
log_i 'start test community/redis'

OUTPUT=$(./dist/"redis-cli${SUFFIX}" --version)
grep -q 'redis-cli 7.2.7' <<<$OUTPUT

if [ $USE_REDIS_DOCKER -eq 1 ]; then
  REDIS_CONTAINER_ID=$(sudo docker run --rm -d -p 6379:6379 redis:7.2.7-alpine --requirepass testpw)
  for i in {1..10}; do
    if sudo docker exec "$REDIS_CONTAINER_ID" redis-cli $REDIS_CONN_OPTS ping | grep -q 'PONG'; then
      break
    fi
    log_w "redis container not started, retry $i"
    sleep 2
  done
  if [ "$i" -ge 10 ]; then log_f 'redis container failed to start'; fi
fi

OUTPUT=$(./dist/"redis-cli${SUFFIX}" $REDIS_CONN_OPTS set tkey tvalue)
grep -q 'OK' <<<$OUTPUT
OUTPUT=$(./dist/"redis-cli${SUFFIX}" $REDIS_CONN_OPTS get tkey)
grep -q 'tvalue' <<<$OUTPUT

[ $USE_REDIS_DOCKER -eq 1 ] && sudo docker stop "$REDIS_CONTAINER_ID" >/dev/null
log_i 'test community/redis success'

########## test main/7zip ##########
log_i 'start test main/7zip'

OUTPUT=$(./dist/"7z${SUFFIX}" --help)
grep -q '7-Zip (z) 24.08' <<<$OUTPUT

echo 'test' >7z_test.txt
OUTPUT=$(./dist/"7z${SUFFIX}" a 7z_test.7z 7z_test.txt)
grep -q 'Everything is Ok' <<<$OUTPUT
OUTPUT=$(./dist/"7z${SUFFIX}" l 7z_test.7z)
grep -q '7z_test.txt' <<<$OUTPUT
rm -f 7z_test.txt
OUTPUT=$(./dist/"7z${SUFFIX}" x 7z_test.7z)
grep -q 'Everything is Ok' <<<$OUTPUT
grep -q 'test' 7z_test.txt

rm -f 7z_test.txt 7z_test.7z
log_i 'test main/7zip success'

########## test main/curl ##########
log_i 'start test main/curl'

OUTPUT=$(./dist/"curl${SUFFIX}" --version)
grep -q 'curl 8.12.1' <<<$OUTPUT

one_time_httpd
OUTPUT=$(./dist/"curl${SUFFIX}" --silent "http://127.0.0.1:$EPHEMERAL_HTTP_PORT")
grep -q 'one_time_httpd' <<<$OUTPUT

log_i 'test main/curl success'

########## test main/htop ##########
log_i 'start test main/htop'

OUTPUT=$(./dist/"htop${SUFFIX}" --version)
grep -q 'htop 3.3.0' <<<$OUTPUT

OUTPUT=$(echo q | ./dist/"htop${SUFFIX}" --no-color)
grep -q 'Load average' <<<$OUTPUT

log_i 'test main/htop success'

########## test main/iperf3 ##########
log_i 'start test main/iperf3'

OUTPUT=$(./dist/"iperf3${SUFFIX}" --version)
grep -q 'iperf 3.17.1' <<<$OUTPUT

./dist/"iperf3${SUFFIX}" --server --daemon --one-off
OUTPUT=$(./dist/"iperf3${SUFFIX}" --client 127.0.0.1 --time 1)
grep -q 'iperf Done' <<<$OUTPUT

log_i 'test main/iperf3 success'

########## test main/iproute2 ##########
log_i 'start test main/iproute2'

OUTPUT=$(./dist/"ss${SUFFIX}" --version)
grep -q 'ss utility, iproute2-6.11.0' <<<$OUTPUT

OUTPUT=$(./dist/"ss${SUFFIX}" --tcp --listening --numeric --processes)
grep -q 'Local Address:Port' <<<$OUTPUT

log_i 'test main/iproute2 success'

########## test main/lsof ##########
log_i 'start test main/lsof'

OUTPUT=$(./dist/"lsof${SUFFIX}" -v 2>&1)
grep -q 'revision: 4.99.4' <<<$OUTPUT

OUTPUT=$(./dist/"lsof${SUFFIX}" -p "$$")
grep -q 'test.sh' <<<$OUTPUT

log_i 'test main/lsof success'

########## test main/mariadb ##########
log_i 'start test main/mariadb'

OUTPUT=$(./dist/"mariadb${SUFFIX}" --version)
grep -q 'from 11.4.5-MariaDB' <<<$OUTPUT
OUTPUT=$(./dist/"mariadb-dump${SUFFIX}" --version)
grep -q 'from 11.4.5-MariaDB' <<<$OUTPUT

if [ $USE_MYSQL_DOCKER -eq 1 ]; then
  MYSQL_CONTAINER_ID=$(sudo docker run --rm -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=testpw mysql:8.0.41)
  for i in {1..10}; do
    if sudo docker exec "$MYSQL_CONTAINER_ID" mysqladmin -h localhost -u root -ptestpw ping 2>&1 | grep -q 'mysqld is alive'; then
      break
    fi
    log_w "mysql container not started, retry $i"
    sleep 3
  done
  if [ "$i" -ge 10 ]; then log_f 'mysql container failed to start'; fi
fi

OUTPUT=$(./dist/"mariadb${SUFFIX}" $MYSQL_CONN_OPTS -e 'select User from mysql.user')
grep -q 'mysql.infoschema' <<<$OUTPUT
OUTPUT=$(./dist/"mariadb-dump${SUFFIX}" $MYSQL_CONN_OPTS mysql user)
grep -q 'Table structure for table' <<<$OUTPUT
grep -q 'Dumping data for table' <<<$OUTPUT
grep -q 'Dump completed on' <<<$OUTPUT

[ $USE_MYSQL_DOCKER -eq 1 ] && sudo docker stop "$MYSQL_CONTAINER_ID" >/dev/null
log_i 'test main/mariadb success'

########## test main/nano ##########
log_i 'start test main/nano'

OUTPUT=$(./dist/"nano${SUFFIX}" --version)
grep -q 'GNU nano, version 8.2' <<<$OUTPUT

echo -e 'Press Ctrl+K then Ctrl+X.\nline will be deleted\nline will be kept' >nano_test.txt
./dist/"nano${SUFFIX}" -I -t +2 nano_test.txt
grep -q 'kept' nano_test.txt
if grep -q 'deleted' nano_test.txt; then log_f 'nano failed to delete line'; fi

rm -f nano_test.txt
log_i 'test main/nano success'

########## test main/netcat-openbsd ##########
log_i 'start test main/netcat-openbsd'

OUTPUT=$(./dist/"nc${SUFFIX}" -h 2>&1)
grep -q 'OpenBSD netcat (Debian patchlevel 1.226-1.1)' <<<$OUTPUT

./dist/"nc${SUFFIX}" -N -l $EPHEMERAL_HTTP_PORT <<<'successful response' >/dev/null &
OUTPUT=$(./dist/"nc${SUFFIX}" -N 127.0.0.1 $EPHEMERAL_HTTP_PORT <<<'request')
grep -q 'successful response' <<<$OUTPUT

log_i 'test main/netcat-openbsd success'

########## test main/nmap ##########
log_i 'start test main/nmap'

OUTPUT=$(./dist/"nmap${SUFFIX}" -V)
grep -q 'Nmap version 7.95' <<<$OUTPUT

OUTPUT=$(./dist/"nmap${SUFFIX}" 127.0.0.1)
grep -q 'Nmap done: 1 IP address (1 host up) scanned' <<<$OUTPUT

log_i 'test main/nmap success'

########## test main/pigz ##########
log_i 'start test main/pigz'

OUTPUT=$(./dist/"pigz${SUFFIX}" --version)
grep -q 'pigz 2.8' <<<$OUTPUT

OUTPUT=$(echo 'pigz_test_compress' | ./dist/"pigz${SUFFIX}" | gzip -d)
grep -q 'pigz_test_compress' <<<$OUTPUT
OUTPUT=$(echo 'pigz_test_decompress' | gzip | ./dist/"pigz${SUFFIX}" -d)
grep -q 'pigz_test_decompress' <<<$OUTPUT

log_i 'test main/pigz success'

########## test main/postgresql17 ##########
log_i 'start test main/postgresql17'

OUTPUT=$(./dist/"psql${SUFFIX}" --version)
grep -q 'psql (PostgreSQL) 17.4' <<<$OUTPUT
OUTPUT=$(./dist/"pg_dump${SUFFIX}" --version)
grep -q 'pg_dump (PostgreSQL) 17.4' <<<$OUTPUT

if [ $USE_POSTGRES_DOCKER -eq 1 ]; then
  POSTGRES_CONTAINER_ID=$(sudo docker run --rm -d -p 5432:5432 -e POSTGRES_PASSWORD=testpw postgres:17.4-alpine)
  for i in {1..10}; do
    if sudo docker exec "$POSTGRES_CONTAINER_ID" pg_isready | grep -q 'accepting connections'; then
      break
    fi
    log_w "postgres container not started, retry $i"
    sleep 3
  done
  if [ "$i" -ge 10 ]; then log_f 'postgres container failed to start'; fi
fi

OUTPUT=$(./dist/"psql${SUFFIX}" $POSTGRES_CONN_OPTS -c "select table_name from information_schema.tables where table_schema='information_schema'")
grep -q 'information_schema_catalog_name' <<<$OUTPUT
OUTPUT=$(./dist/"pg_dump${SUFFIX}" $POSTGRES_CONN_OPTS)
grep -q 'PostgreSQL database dump complete' <<<$OUTPUT

[ $USE_POSTGRES_DOCKER -eq 1 ] && sudo docker stop "$POSTGRES_CONTAINER_ID" >/dev/null
log_i 'test main/postgresql17 success'

########## test main/procps-ng ##########
log_i 'start test main/procps-ng'

OUTPUT=$(./dist/"ps${SUFFIX}" --version)
grep -q 'procps-ng 4.0.4' <<<$OUTPUT

OUTPUT=$(./dist/"ps${SUFFIX}" aux)
grep -q 'test.sh' <<<$OUTPUT

log_i 'test main/procps-ng success'

########## test main/rsync ##########
log_i 'start test main/rsync'

OUTPUT=$(./dist/"rsync${SUFFIX}" --version)
grep -q 'rsync  version 3.4.0' <<<$OUTPUT

echo 'rsync_test' >rsync_from.txt
OUTPUT=$(./dist/"rsync${SUFFIX}" -avz rsync_from.txt rsync_to.txt)
grep -q -E 'total size is .* speedup is ' <<<$OUTPUT
grep -q 'rsync_test' rsync_to.txt

rm -f rsync_from.txt rsync_to.txt
log_i 'test main/rsync success'

########## test main/socat ##########
log_i 'start test main/socat'

OUTPUT=$(./dist/"socat${SUFFIX}" -V)
grep -q 'socat version 1.8.0.1' <<<$OUTPUT

one_time_httpd
./dist/"socat${SUFFIX}" TCP-LISTEN:18090 "TCP4:127.0.0.1:$EPHEMERAL_HTTP_PORT" &
OUTPUT=$(./dist/"curl${SUFFIX}" --silent http://127.0.0.1:18090)
grep -q 'one_time_httpd' <<<$OUTPUT

log_i 'test main/socat success'

########## test main/strace ##########
log_i 'start test main/strace'

OUTPUT=$(./dist/"strace${SUFFIX}" --version)
grep -q 'strace -- version 6.12' <<<$OUTPUT

OUTPUT=$(./dist/"strace${SUFFIX}" -o strace_out.txt cat /dev/null)
grep -q -E '^open' strace_out.txt
grep -q -E '^read' strace_out.txt
grep -q -E '^close' strace_out.txt

rm -f strace_out.txt
log_i 'test main/strace success'

########## test main/tcpdump ##########
log_i 'start test main/tcpdump'

OUTPUT=$(./dist/"tcpdump${SUFFIX}" --version)
grep -q 'version 4.99.5' <<<$OUTPUT

one_time_httpd
sudo ./dist/"tcpdump${SUFFIX}" --interface lo -A -n -c 5 "tcp src port $EPHEMERAL_HTTP_PORT" >tcpdump.data &
sleep 1
OUTPUT=$(./dist/"curl${SUFFIX}" --silent "http://127.0.0.1:$EPHEMERAL_HTTP_PORT")
grep -q 'one_time_httpd' <<<$OUTPUT
sleep 1
grep -q 'one_time_httpd' tcpdump.data

rm -f tcpdump.data
log_i 'test main/tcpdump success'

########## test main/vim ##########
log_i 'start test main/vim'

OUTPUT=$(./dist/"vim${SUFFIX}" --version)
grep -q 'VIM - Vi IMproved 9.1' <<<$OUTPUT

echo 'test' >vim_test.txt
OUTPUT=$(./dist/"vim${SUFFIX}" --not-a-term -u NONE -N +'%s/test/test_vim/g' +'wq' vim_test.txt)
grep -q 'test_vim' vim_test.txt
OUTPUT=$(./dist/"xxd${SUFFIX}" -ps vim_test.txt)
grep -q '746573745f76696d0a' <<<$OUTPUT

rm -f vim_test.txt
log_i 'test main/vim success'

########## test main/wget ##########
log_i 'start test main/wget'

OUTPUT=$(./dist/"wget${SUFFIX}" --version)
grep -q 'GNU Wget 1.25.0' <<<$OUTPUT

one_time_httpd
OUTPUT=$(./dist/"wget${SUFFIX}" --quiet -O - "http://127.0.0.1:$EPHEMERAL_HTTP_PORT")
grep -q 'one_time_httpd' <<<$OUTPUT

log_i 'test main/wget success'
