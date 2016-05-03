#!/bin/bash

# check if we have a Ubuntu 16.04
UBUNTU_RELEASE=$(lsb_release -c | sed 's/^.*:[[:space:]]*//g')
echo "Identified Ubuntu release $UBUNTU_RELEASE"

if [ "$UBUNTU_RELEASE" == "xenial" ]
then
  # it seems to be 16.04, we can install owncloud from the standard repository
  echo "Installation from standard repository"
  sudo apt-get install --assume-yes owncloud-client owncloud-client-cmd owncloud-client-doc owncloud-client-l10n
else
  # Owncloud installation for older Ubuntu releases
  echo "Installation from opensuse repository"
  wget -q -O - http://download.opensuse.org/repositories/isv:ownCloud:desktop/Ubuntu_14.04/Release.key | sudo apt-key add -

  sudo sh -c "echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/Ubuntu_14.04/ /' > /etc/apt/sources.list.d/owncloud-client.list"
  sudo apt-get update
  sudo apt-get --assume-yes install owncloud-client
fi
