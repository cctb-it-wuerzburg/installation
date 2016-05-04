#!/bin/bash

# following the instruction on https://help.ubuntu.com/community/UbuntuLTSP/RaspberryPi

cat <<EOF | tee /etc/ltsp/ltsp-build-client-raspi3.conf
# This is a configuration file to build an LTSP chroot for Raspberry Pi 2.
MOUNT_PACKAGE_DIR="/var/cache/apt/archives"
APT_KEYS="/etc/ltsp/ts_sch_gr-ppa.key"
EXTRA_MIRROR="http://ppa.launchpad.net/ts.sch.gr/ppa/ubuntu $DIST main"
KERNEL_ARCH="raspi2"
LATE_PACKAGES="dosfstools less nano"
EOF

add-apt-repository --yes ppa:ts.sch.gr
apt-key export 03AFA832 > /etc/ltsp/ts_sch_gr-ppa.key
apt-get update
apt-get --assume-yes dist-upgrade
apt-get --assume-yes install qemu-user-static binfmt-support
ltsp-build-client --arch armhf --config /etc/ltsp/ltsp-build-client-raspi3.conf
