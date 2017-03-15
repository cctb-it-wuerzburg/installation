#!/bin/bash

# Following the instructions from
# http://ubuntuforums.org/showthread.php?t=2173749

# chmod instruction obtained from
# https://www.thefanclub.co.za/how-to/configure-update-auto-login-ubuntu-12-04-ltsp-fat-clients

# get the current IP address
IP_ADDRESS=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')

# create a set for the architectures: amd64, i386
for ltsp_arch in i386 amd64
do
    sudo ltsp-build-client --arch ${ltsp_arch}
    sudo sed -i 's/ipappend 2/ipappend 3/g' /var/lib/tftpboot/ltsp/${ltsp_arch}/pxelinux.cfg/default

    sudo chroot /opt/ltsp/${ltsp_arch} apt-get update
    sudo chroot /opt/ltsp/${ltsp_arch} apt-get upgrade

    # add a genomics user to the images
    sudo chroot /opt/ltsp/${ltsp_arch} mkdir -p /home2
    sudo chroot /opt/ltsp/${ltsp_arch} useradd --comment "Genomics user" --home-dir /home2/genomics --create-home --shell /bin/bash --password '$6$wFb.dfXL3p5$MRmV2SA49DW/XIZJotdZuQ2rfeHy5/BPy4/x257pT1HR8sfz1VadxOKIjbtTqsfwUjbZhxV1b7YAKgv2ToYsA0' --groups sudo genomics

    # install openssh-server to allow login into the nodes
    # (taken from https://help.ubuntu.com/community/UbuntuLTSP/ClientTroubleshooting)
    sudo mount --bind /dev /opt/ltsp/${ltsp_arch}/dev
    sudo mount -t proc none /opt/ltsp/${ltsp_arch}/proc
    LTSP_HANDLE_DAEMONS=false sudo chroot /opt/ltsp/${ltsp_arch} apt-get install --assume-yes openssh-server

    # remove the ssh_host_*_keys from exclude list
    sudo sed -i '/^etc\/ssh\/ssh_host_*_key/d' /etc/ltsp/ltsp-update-image.excludes

    # Deinstall lightlocker and lightlocker
    # this caused problems with screen locking
    sudo chroot /opt/ltsp/${ltsp_arch} apt-get purge --assume-yes light-locker light-locker-settings

    # Set a lts.conf file to enable the correct SERVER and DHCP on the clients
    echo "[Default]
# For troubleshooting, the following open a local console with Alt+Ctrl+F2.
SCREEN_02=shell
SCREEN_07=ldm

LDM_SYSLOG=True
SERVER=${IP_ADDRESS}
NETWORK_COMPRESSION=True

# this is the important line to enable DHCP on the client machines
NET_DEVICE_METHOD=dhcp
" | sudo tee /var/lib/tftpboot/ltsp/${ltsp_arch}/lts.conf

    # move the created lts.conf to /opt/ltsp/${ltsp_arch}/etc/lts.conf
    if [ -e /opt/ltsp/${ltsp_arch}/etc/lts.conf ]
    then
	sudo mv /opt/ltsp/${ltsp_arch}/etc/lts.conf /opt/ltsp/${ltsp_arch}/etc/lts.conf.old
    fi
    sudo cp /var/lib/tftpboot/ltsp/${ltsp_arch}/lts.conf /opt/ltsp/${ltsp_arch}/etc/lts.conf

    # install check_mk into the clients
    sudo chroot /opt/ltsp/${ltsp_arch} apt-get --assume-yes install xinetd check-mk-agent check-mk-agent-logwatch
    sudo chroot /opt/ltsp/${ltsp_arch} cp /etc/xinetd.d/check_mk /etc/xinetd.d/check_mk.bak
    sudo chroot /opt/ltsp/${ltsp_arch} sed -i '/disable/s/^.*$/\tdisable        = no/' /etc/xinetd.d/check_mk
    sudo chroot /opt/ltsp/${ltsp_arch} sed -i '/only_from/s/^.*$/\tonly_from = 132.187.22.169/' /etc/xinetd.d/check_mk

    # umount the mounts
    sudo umount /opt/ltsp/${ltsp_arch}/dev
    sudo umount /opt/ltsp/${ltsp_arch}/proc

done

# update ltsp-image
sudo ltsp-update-image
find /var/lib/tftpboot/ltsp/ -name default | sudo xargs sed -i 's/ipappend 2/ipappend 3/g'
