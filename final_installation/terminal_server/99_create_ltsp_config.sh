#!/bin/bash

# Following the instructions from
# http://ubuntuforums.org/showthread.php?t=2173749

# chmod instruction obtained from
# https://www.thefanclub.co.za/how-to/configure-update-auto-login-ubuntu-12-04-ltsp-fat-clients

# get the current IP address
IP_ADDRESS=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')

sudo ltsp-build-client --arch amd64
sudo sed -i 's/ipappend 2/ipappend 3/g' /var/lib/tftpboot/ltsp/amd64/pxelinux.cfg/default

sudo chroot /opt/ltsp/amd64 apt-get update
sudo chroot /opt/ltsp/amd64 apt-get upgrade

# add a genomics user to the images
sudo chroot /opt/ltsp/amd64 mkdir -p /home2
sudo chroot /opt/ltsp/amd64 useradd --comment "Genomics user" --home-dir /home2/genomics --create-home --shell /bin/bash --password '$6$wFb.dfXL3p5$MRmV2SA49DW/XIZJotdZuQ2rfeHy5/BPy4/x257pT1HR8sfz1VadxOKIjbtTqsfwUjbZhxV1b7YAKgv2ToYsA0' --groups sudo genomics

# install openssh-server to allow login into the nodes
# (taken from https://help.ubuntu.com/community/UbuntuLTSP/ClientTroubleshooting)
sudo mount --bind /dev /opt/ltsp/amd64/dev
sudo mount -t proc none /opt/ltsp/amd64/proc
LTSP_HANDLE_DAEMONS=false sudo chroot /opt/ltsp/amd64 apt-get install --assume-yes openssh-server

# remove the ssh_host_*_keys from exclude list
sudo sed -i '/^etc\/ssh\/ssh_host_*_key/d' /etc/ltsp/ltsp-update-image.excludes

# Deinstall lightlocker and lightlocker
# this caused problems with screen locking
sudo chroot /opt/ltsp/amd64 apt-get purge --assume-yes light-locker light-locker-settings

# Set a lts.conf file to enable the correct SERVER and DHCP on the clients
cat <<EOF | sudo tee /var/lib/tftpboot/ltsp/amd64/lts.conf
[Default]
# For troubleshooting, the following open a local console with Alt+Ctrl+F2.
SCREEN_02=shell
SCREEN_07=ldm

LDM_SYSLOG=True
SERVER=${IP_ADDRESS}
NETWORK_COMPRESSION=True

# this is the important line to enable DHCP on the client machines
NET_DEVICE_METHOD=dhcp

EOF

# move the created lts.conf to /opt/ltsp/amd64/etc/lts.conf
if [ -e /opt/ltsp/amd64/etc/lts.conf ]
then
  sudo mv /opt/ltsp/amd64/etc/lts.conf /opt/ltsp/amd64/etc/lts.conf.old
fi
sudo cp /var/lib/tftpboot/ltsp/amd64/lts.conf /opt/ltsp/amd64/etc/lts.conf

# install check_mk into the clients
sudo chroot /opt/ltsp/amd64 apt-get --assume-yes install xinetd check-mk-agent check-mk-agent-logwatch
sudo chroot /opt/ltsp/amd64 cp /etc/xinetd.d/check_mk /etc/xinetd.d/check_mk.bak
sudo chroot /opt/ltsp/amd64 sed -i '/disable/s/^.*$/\tdisable        = no/' /etc/xinetd.d/check_mk
sudo chroot /opt/ltsp/amd64 sed -i '/only_from/s/^.*$/\tonly_from = 132.187.22.169/' /etc/xinetd.d/check_mk

# update ltsp-image
sudo ltsp-update-image
sudo sed -i 's/ipappend 2/ipappend 3/g' /var/lib/tftpboot/ltsp/amd64/pxelinux.cfg/default
