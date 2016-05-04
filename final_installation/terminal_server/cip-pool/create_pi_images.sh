#!/bin/bash

# following the instruction on https://help.ubuntu.com/community/UbuntuLTSP/RaspberryPi

# get the distribution name
DIST=$(lsb_release -c | sed 's/.*Codename:[[:space:]]*//g;s/[[:space:]]*$//g;')

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

# enter image and add important packages

# Install the desktop environment you prefer.
# This is for the lubuntu-desktop task:
ltsp-chroot -ma armhf bash -c "export FLASH_KERNEL_SKIP=true;
   apt install --assume-yes --no-install-recommends xubuntu-desktop^"

# Install any additional software that you want:
ltsp-chroot -ma armhf bash -c "export FLASH_KERNEL_SKIP=true;
   apt install --assume-yes ubuntu-restricted-extras"

# Install language packs. Replace "-en" below with your own language(s):
ltsp-chroot -ma armhf bash -c "export FLASH_KERNEL_SKIP=true;
   apt install --assume-yes language-pack-en language-pack-de"
ltsp-chroot -ma armhf bash -c "export FLASH_KERNEL_SKIP=true;
   apt install --assume-yes \$(check-language-support)"
