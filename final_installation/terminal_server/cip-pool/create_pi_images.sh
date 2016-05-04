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
ltsp-chroot -ma armhf

export FLASH_KERNEL_SKIP=true
# Install the desktop environment you prefer.
# This is for the lubuntu-desktop task:
apt-get install --no-install-recommends xubuntu-desktop^
# This is for the gnome-flashback session:
#apt-get install ubuntu-desktop gnome-session-flashback

# Install any additional software that you want:
apt-get install ubuntu-restricted-extras

# Install language packs. Replace "-en" below with your own language(s):
apt-get install language-pack-en language-pack-de
apt-get install $(check-language-support)
exit
