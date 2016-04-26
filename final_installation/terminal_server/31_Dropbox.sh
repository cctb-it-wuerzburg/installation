#!/bin/bash

# Dropbox installation

# we want to install amd64 packages
REQUIRED_ARCH=amd64

# get the list of Linux installation packages
TEMPFILENAME=$(tempfile)
wget -O "$TEMPFILENAME" 'https://www.dropbox.com/install?os=lnx'

# how many possible packages are present
NUM_PACKAGES=$(grep -oPi '(?<=href=")[^"]*?ubuntu[^"]*'"$REQUIRED_ARCH"'.deb' "$TEMPFILENAME" | wc -l)

if [ "$NUM_PACKAGES" -eq 1 ]
then
  DOWNLOAD_PACKAGE=$(grep -oPi '(?<=href=")[^"]*?ubuntu[^"]*'"$REQUIRED_ARCH"'.deb' "$TEMPFILENAME")
  echo "Found one package to install. Package location is $DOWNLOAD_PACKAGE"
  wget -O /tmp/dropbox.deb 'https://www.dropbox.com'"$DOWNLOAD_PACKAGE"
  sudo dpkg --install /tmp/dropbox.deb
  sudo apt-get --assume-yes install -f
else
  # something went wrong!
  echo "Number of expected packages is 1 but found $NUM_PACKAGES Therefore no Dropbox will be installed!"
fi
