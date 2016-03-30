#!/bin/sh

wget -O - http://ardownload.adobe.com/pub/adobe/reader/unix/9.x/9.5.5/enu/AdbeRdr9.5.5-1_i386linux_enu.deb > /tmp/acroread.deb

sudo dpkg --install /tmp/acroread.deb

sudo apt-get --assume-yes install -f
