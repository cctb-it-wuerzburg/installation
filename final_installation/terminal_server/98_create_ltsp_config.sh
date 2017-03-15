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

    # default x2gosession file
    sudo chroot /opt/ltsp/${ltsp_arch} sudo mkdir -p /home2/genomics/.x2goclient
    sudo chroot /opt/ltsp/${ltsp_arch} cat <<EOF  | sudo tee /home2/genomics/.x2goclient/sessions
[20120412164434850]
speed=4
pack=16m-jpeg
quality=9
fstunnel=true
export="/media/usb0:1;"
iconvto=ISO8859-1
iconvfrom=UTF-8
useiconv=true
fullscreen=true
width=1280
multidisp=false
display=1
height=1024
dpi=96
setdpi=false
xinerama=false
usekbd=true
layout=de
type=auto
sound=true
soundsystem=pulse
startsoundsystem=true
soundtunnel=true
defsndport=true
sndport=4713
print=true
name=wbbi162
icon=/opt/thinclient/logo_big.png
host=132.187.22.162
user=
key=
sshport=22
autologin=false
krblogin=false
rootless=false
published=false
applications=WWWBROWSER, MAILCLIENT, OFFICE, TERMINAL
command=XFCE
rdpoptions=
rdpserver=
xdmcpserver=localhost
maxdim=false
rdpclient=rdesktop
directrdpsettings=
clipboard=both
rdpport=3389
krbdelegation=false
directrdp=false
usesshproxy=false
sshproxytype=SSH
sshproxyuser=
sshproxykeyfile=
sshproxyhost=
sshproxyport=22
sshproxysamepass=false
sshproxysameuser=false
sshproxyautologin=false
sshproxykrblogin=false

[20120412164434851]
speed=4
pack=16m-jpeg
quality=9
fstunnel=true
export="/media/usb0:1;"
iconvto=ISO8859-1
iconvfrom=UTF-8
useiconv=true
fullscreen=true
width=1280
multidisp=false
display=1
height=1024
dpi=96
setdpi=false
xinerama=false
usekbd=true
layout=de
type=auto
sound=true
soundsystem=pulse
startsoundsystem=true
soundtunnel=true
defsndport=true
sndport=4713
print=true
name=Gaia 1
icon=/opt/thinclient/logo_big.png
host=132.187.198.11
user=
key=
sshport=22
autologin=false
krblogin=false
rootless=false
published=false
applications=WWWBROWSER, MAILCLIENT, OFFICE, TERMINAL
command=XFCE
rdpoptions=
rdpserver=
xdmcpserver=localhost
maxdim=false
rdpclient=rdesktop
directrdpsettings=
clipboard=both
rdpport=3389
krbdelegation=false
directrdp=false
usesshproxy=false
sshproxytype=SSH
sshproxyuser=
sshproxykeyfile=
sshproxyhost=
sshproxyport=22
sshproxysamepass=false
sshproxysameuser=false
sshproxyautologin=false
sshproxykrblogin=false

[20120412164434852]
speed=4
pack=16m-jpeg
quality=9
fstunnel=true
export="/media/usb0:1;"
iconvto=ISO8859-1
iconvfrom=UTF-8
useiconv=true
fullscreen=true
width=1280
multidisp=false
display=1
height=1024
dpi=96
setdpi=false
xinerama=false
usekbd=true
layout=de
type=auto
sound=true
soundsystem=pulse
startsoundsystem=true
soundtunnel=true
defsndport=true
sndport=4713
print=true
name=Gaia 2
icon=/opt/thinclient/logo_big.png
host=132.187.198.12
user=
key=
sshport=22
autologin=false
krblogin=false
rootless=false
published=false
applications=WWWBROWSER, MAILCLIENT, OFFICE, TERMINAL
command=XFCE
rdpoptions=
rdpserver=
xdmcpserver=localhost
maxdim=false
rdpclient=rdesktop
directrdpsettings=
clipboard=both
rdpport=3389
krbdelegation=false
directrdp=false
usesshproxy=false
sshproxytype=SSH
sshproxyuser=
sshproxykeyfile=
sshproxyhost=
sshproxyport=22
sshproxysamepass=false
sshproxysameuser=false
sshproxyautologin=false
sshproxykrblogin=false

[20120412164434853]
speed=4
pack=16m-jpeg
quality=9
fstunnel=true
export="/media/usb0:1;"
iconvto=ISO8859-1
iconvfrom=UTF-8
useiconv=true
fullscreen=true
width=1280
multidisp=false
display=1
height=1024
dpi=96
setdpi=false
xinerama=false
usekbd=true
layout=de
type=auto
sound=true
soundsystem=pulse
startsoundsystem=true
soundtunnel=true
defsndport=true
sndport=4713
print=true
name=Gaia 3
icon=/opt/thinclient/logo_big.png
host=132.187.198.17
user=
key=
sshport=22
autologin=false
krblogin=false
rootless=false
published=false
applications=WWWBROWSER, MAILCLIENT, OFFICE, TERMINAL
command=XFCE
rdpoptions=
rdpserver=
xdmcpserver=localhost
maxdim=false
rdpclient=rdesktop
directrdpsettings=
clipboard=both
rdpport=3389
krbdelegation=false
directrdp=false
usesshproxy=false
sshproxytype=SSH
sshproxyuser=
sshproxykeyfile=
sshproxyhost=
sshproxyport=22
sshproxysamepass=false
sshproxysameuser=false
sshproxyautologin=false
sshproxykrblogin=false

[20120412164434854]
speed=4
pack=16m-jpeg
quality=9
fstunnel=true
export="/media/usb0:1;"
iconvto=ISO8859-1
iconvfrom=UTF-8
useiconv=true
fullscreen=true
width=1280
multidisp=false
display=1
height=1024
dpi=96
setdpi=false
xinerama=false
usekbd=true
layout=de
type=auto
sound=true
soundsystem=pulse
startsoundsystem=true
soundtunnel=true
defsndport=true
sndport=4713
print=true
name=Gaia 4
icon=/opt/thinclient/logo_big.png
host=132.187.198.18
user=
key=
sshport=22
autologin=false
krblogin=false
rootless=false
published=false
applications=WWWBROWSER, MAILCLIENT, OFFICE, TERMINAL
command=XFCE
rdpoptions=
rdpserver=
xdmcpserver=localhost
maxdim=false
rdpclient=rdesktop
directrdpsettings=
clipboard=both
rdpport=3389
krbdelegation=false
directrdp=false
usesshproxy=false
sshproxytype=SSH
sshproxyuser=
sshproxykeyfile=
sshproxyhost=
sshproxyport=22
sshproxysamepass=false
sshproxysameuser=false
sshproxyautologin=false
sshproxykrblogin=false
EOF
    sudo chown -R genomics /home2/genomics/.x2goclient
    
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

    # install x2goclient
    sudo apt install --assume-yes x2goclient

    # prepare x2go
    cat <<EOF | sudo tee /var/lib/tftpboot/ltsp/${ltsp_arch}/lts.conf
#!/bin/sh
#
# The following script works for LTSP5.
#
# This software is licensed under the Gnu General Public License.
# The full text of which can be found at http://www.LTSP.org/license.txt
#
#
#       To customize the kiosk session, you can add "homedir" files
#       to $chroot/usr/local/share/ltspkiosk/home/ 
#       AND to add startup scripts that run as the user, you can add 
#       them as executables or symlinks to executables in:
#       $chroot/usr/local/share/ltspkiosk/startup

PATH=/bin:$PATH; export PATH
. /usr/share/ltsp/screen-x-common

[ -n "$1" ] && KIOSK_EXE=$1
[ -n "$2" ] && KIOSK_OPTIONS=$2

if [ -z "${KIOSK_EXE}" ]; then
    if [ -x "/usr/bin/firefox" ]; then
        KIOSK_EXE=/usr/bin/firefox
    elif [ -x "/usr/bin/google-chrome" ]; then
        KIOSK_EXE=/usr/bin/google-chrome
    elif [ -x "/usr/bin/opera" ]; then
        KIOSK_EXE=/usr/bin/opera
    else
        KIOSK_EXE=unknown
    fi
fi
 
if boolean_is_true "${KIOSK_DAEMON:-"False"}"; then
    export XINITRC_DAEMON="True"
fi

if [ -x /usr/share/ltsp/xinitrc ]; then
    xinitrc=/usr/share/ltsp/xinitrc
fi

KIOSKUSER=${KIOSKUSER:-"ltspkiosk"}
if [ -z "$(getent passwd ${KIOSKUSER})" ]; then
    # create a ltspkiosk user
    adduser --no-create-home --disabled-password --gecos ,,, ${KIOSKUSER}
    # Create a tmpdir to be our homedir
    TMPDIR=$(mktemp -d /tmp/.kiosk-XXXXXX)
    chown ${KIOSKUSER} ${TMPDIR}
    # Edit passwd homedir entry for programs that look it up from there
    sed -i -e '\|'${KIOSKUSER}'|s|[^:]*\(:[^:]*\)$|'$TMPDIR'\1|' /etc/passwd
fi

su - ${KIOSKUSER} -c "XINITRC_DAEMON=${XINITRC_DAEMON} KIOSK_WM=${KIOSK_WM} xinit $xinitrc /usr/share/ltsp/kioskSession ${KIOSK_EXE} ${KIOSK_OPTIONS} -- ${DISPLAY} vt${TTY} ${X_ARGS} -br" >/dev/null

if [ ! -z ${TMPDIR} ];
then
    rm -rf ${TMPDIR}
fi" | sudo tee /usr/share/ltsp/screen.d/x2go

    sudo chmod +x /usr/share/ltsp/screen.d/x2go
    
    # Set a lts.conf file to enable the correct SERVER and DHCP on the clients
    echo "[Default]
# For troubleshooting, the following open a local console with Alt+Ctrl+F2.
#SCREEN_02=shell
SCREEN_08=ldm
SCREEN_07=x2go
KIOSK_EXE="/usr/bin/x2goclient --maximize --link=lan --geometry=fullscreen --thinclient --haltbt --add-to-known-hosts --xinerama --no-menu --home=/home2/genomics/"
KIOSKUSER=genomics

LDM_SYSLOG=True
SERVER=${IP_ADDRESS}
NETWORK_COMPRESSION=True

# this is the important line to enable DHCP on the client machines
NET_DEVICE_METHOD=dhcp

EOF

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

# update authfile for nbd-server
find /etc/nbd-server/conf.d/ -name "*.conf" | sudo xargs sed -i 's/^\(authfile\)/#\1/'
# restart server
sudo service nbd-server restart 
