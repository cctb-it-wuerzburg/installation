#!/bin/bash

#
# install the xubuntu-desktop and some additionally packages
#

#
# Part of the installation are the ttf-mscorefonts installation,
# therefore we need to accept a licence. This is automated following
# the instruction at:
#                      http://askubuntu.com/questions/16225/how-can-i-accept-the-microsoft-eula-agreement-for-ttf-mscorefonts-installer
#

echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | \
    sudo debconf-set-selections
echo ttf-mscorefonts-installer msttcorefonts/present-mscorefonts-eula note | \
    sudo debconf-set-selections

sudo apt-get install --assume-yes \
    xubuntu-artwork \
    xubuntu-community-wallpapers \
    xubuntu-default-settings \
    xubuntu-desktop \
    xubuntu-docs \
    xubuntu-icon-theme \
    xubuntu-restricted-addons \
    xubuntu-restricted-extras \
    xubuntu-wallpapers
