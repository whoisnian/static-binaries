# prepare static server via https://github.com/whoisnian/share-Go
share-Go -d -l :54321 -p ~/Share

# common test commands
wget http://192.168.122.1:54321/api/download/7z_v20251015.0_linux_amd64 && chmod +x 7z_v20251015.0_linux_amd64
wget http://192.168.122.1:54321/api/download/static-binaries-artifact-amd64.zip
wget http://192.168.122.1:54321/api/download/test.sh && chmod +x test.sh
./7z_v20251015.0_linux_amd64 x -odist static-binaries-artifact-amd64.zip
./test.sh

# print vm info
grep '^PRETTY_NAME=' /etc/os-release
uname -m
uname -r
ldd --version

# delete existing vm
virsh --connect qemu:///system undefine --domain devbox --remove-all-storage --nvram





# start test vms via https://github.com/whoisnian/virt-launcher
##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####
./output/virt-launcher -d -os debian13 -arch amd64 -n devbox -cpu 4 -mem 4096 -s 20G -key "$(cat ~/.ssh/id_ed25519.pub)"
ssh "debian@$(virsh --connect qemu:///system domifaddr --domain devbox | grep -Po '\d+\.\d+\.\d+\.\d+')"

./output/virt-launcher -d -os debian12 -arch amd64 -n devbox -cpu 4 -mem 4096 -s 20G -key "$(cat ~/.ssh/id_ed25519.pub)"
ssh "debian@$(virsh --connect qemu:///system domifaddr --domain devbox | grep -Po '\d+\.\d+\.\d+\.\d+')"

./output/virt-launcher -d -os debian11 -arch amd64 -n devbox -cpu 4 -mem 4096 -s 20G -key "$(cat ~/.ssh/id_ed25519.pub)"
ssh "debian@$(virsh --connect qemu:///system domifaddr --domain devbox | grep -Po '\d+\.\d+\.\d+\.\d+')"

./output/virt-launcher -d -os ubuntu24.04 -arch amd64 -n devbox -cpu 4 -mem 4096 -s 20G -key "$(cat ~/.ssh/id_ed25519.pub)"
ssh "ubuntu@$(virsh --connect qemu:///system domifaddr --domain devbox | grep -Po '\d+\.\d+\.\d+\.\d+')"

./output/virt-launcher -d -os ubuntu22.04 -arch amd64 -n devbox -cpu 4 -mem 4096 -s 20G -key "$(cat ~/.ssh/id_ed25519.pub)"
ssh "ubuntu@$(virsh --connect qemu:///system domifaddr --domain devbox | grep -Po '\d+\.\d+\.\d+\.\d+')"

./output/virt-launcher -d -os ubuntu20.04 -arch amd64 -n devbox -cpu 4 -mem 4096 -s 20G -key "$(cat ~/.ssh/id_ed25519.pub)"
ssh "ubuntu@$(virsh --connect qemu:///system domifaddr --domain devbox | grep -Po '\d+\.\d+\.\d+\.\d+')"

./output/virt-launcher -d -os ubuntu18.04 -arch amd64 -n devbox -cpu 4 -mem 4096 -s 20G -key "$(cat ~/.ssh/id_ed25519.pub)"
ssh "ubuntu@$(virsh --connect qemu:///system domifaddr --domain devbox | grep -Po '\d+\.\d+\.\d+\.\d+')"

./output/virt-launcher -d -os alpinelinux3.22 -arch amd64 -n devbox -cpu 4 -mem 4096 -s 20G -key "$(cat ~/.ssh/id_ed25519.pub)"
ssh "alpine@$(virsh --connect qemu:///system domifaddr --domain devbox | grep -Po '\d+\.\d+\.\d+\.\d+')"
doas apk add bash sudo

./output/virt-launcher -d -os alpinelinux3.21 -arch amd64 -n devbox -cpu 4 -mem 4096 -s 20G -key "$(cat ~/.ssh/id_ed25519.pub)"
ssh "alpine@$(virsh --connect qemu:///system domifaddr --domain devbox | grep -Po '\d+\.\d+\.\d+\.\d+')"
doas apk add bash sudo

./output/virt-launcher -d -os rocky9 -arch amd64 -n devbox -cpu 4 -mem 4096 -s 20G -key "$(cat ~/.ssh/id_ed25519.pub)"
ssh "rocky@$(virsh --connect qemu:///system domifaddr --domain devbox | grep -Po '\d+\.\d+\.\d+\.\d+')"

./output/virt-launcher -d -os rocky8 -arch amd64 -n devbox -cpu 4 -mem 4096 -s 20G -key "$(cat ~/.ssh/id_ed25519.pub)"
ssh "rocky@$(virsh --connect qemu:///system domifaddr --domain devbox | grep -Po '\d+\.\d+\.\d+\.\d+')"

./output/virt-launcher -d -os centos7.0 -arch amd64 -n devbox -cpu 4 -mem 4096 -s 20G -key "$(cat ~/.ssh/id_ed25519.pub)"
ssh "centos@$(virsh --connect qemu:///system domifaddr --domain devbox | grep -Po '\d+\.\d+\.\d+\.\d+')"


ls -hl ~/.cache/virt-launcher/images
# total 14G
# -rw-r--r-- 1 nian nian 926M Oct 19 21:17 CentOS-7-aarch64-GenericCloud-2211.qcow2
# -rw-r--r-- 1 nian nian 862M Oct 19 02:53 CentOS-7-x86_64-GenericCloud-2211.qcow2
# -rw-r--r-- 1 nian nian 1.8G Oct 19 21:14 Rocky-8-GenericCloud-Base-8.10-20240528.0.aarch64.qcow2
# -rw-r--r-- 1 nian nian 2.0G Oct 19 02:59 Rocky-8-GenericCloud-Base-8.10-20240528.0.x86_64.qcow2
# -rw-r--r-- 1 nian nian 501M Oct 19 21:03 Rocky-9-GenericCloud-Base-9.6-20250531.0.aarch64.qcow2
# -rw-r--r-- 1 nian nian 599M Oct 19 02:58 Rocky-9-GenericCloud-Base-9.6-20250531.0.x86_64.qcow2
# -rw-r--r-- 1 nian nian 387M Oct 19 02:28 bionic-server-cloudimg-amd64.img
# -rw-r--r-- 1 nian nian 360M Oct 19 19:03 bionic-server-cloudimg-arm64.img
# -rw-r--r-- 1 nian nian 273M Oct 19 02:10 debian-11-genericcloud-amd64-20251015-2266.qcow2
# -rw-r--r-- 1 nian nian 252M Oct 19 18:33 debian-11-genericcloud-arm64-20251015-2266.qcow2
# -rw-r--r-- 1 nian nian 332M Oct 19 00:38 debian-12-genericcloud-amd64-20251006-2257.qcow2
# -rw-r--r-- 1 nian nian 324M Oct 19 18:21 debian-12-genericcloud-arm64-20251006-2257.qcow2
# -rw-r--r-- 1 nian nian 325M Oct 19 02:31 debian-13-genericcloud-amd64-20251006-2257.qcow2
# -rw-r--r-- 1 nian nian 320M Oct 19 03:47 debian-13-genericcloud-arm64-20251006-2257.qcow2
# -rw-r--r-- 1 nian nian 618M Oct 19 02:26 focal-server-cloudimg-amd64.img
# -rw-r--r-- 1 nian nian 587M Oct 20 00:31 focal-server-cloudimg-arm64.img
# -rw-r--r-- 1 nian nian 198M Oct 19 20:49 generic_alpine-3.21.5-aarch64-uefi-cloudinit-r0.qcow2
# -rw-r--r-- 1 nian nian 172M Oct 19 02:37 generic_alpine-3.21.5-x86_64-bios-cloudinit-r0.qcow2
# -rw-r--r-- 1 nian nian 210M Oct 19 20:49 generic_alpine-3.22.2-aarch64-uefi-cloudinit-r0.qcow2
# -rw-r--r-- 1 nian nian 185M Oct 19 02:41 generic_alpine-3.22.2-x86_64-bios-cloudinit-r0.qcow2
# -rw-r--r-- 1 nian nian 658M Oct 19 02:23 jammy-server-cloudimg-amd64.img
# -rw-r--r-- 1 nian nian 631M Oct 19 18:56 jammy-server-cloudimg-arm64.img
# -rw-r--r-- 1 nian nian 596M Oct 19 02:17 noble-server-cloudimg-amd64.img
# -rw-r--r-- 1 nian nian 590M Oct 19 18:41 noble-server-cloudimg-arm64.img
