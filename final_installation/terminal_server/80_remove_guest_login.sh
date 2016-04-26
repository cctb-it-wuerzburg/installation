#!/bin/bash

# check if we have a Ubuntu 16.04
UBUNTU_RELEASE=$(lsb_release -c | sed 's/^.*:[[:space:]]*//g')
echo "Identified Ubuntu release $UBUNTU_RELEASE"

if [ "$UBUNTU_RELEASE" == "xenial" ]
then
  # it seems to be 16.04, we do not need to disable guest login
  echo "Ubuntu 16.04 found, therefore no guest login needs to be disabled."
else
  # Before Ubuntu 16.04, we need to disable guest login
  echo "Older release means we need to disable guest login"
  sudo su root -c "printf '[SeatDefaults]\nallow-guest=false\n' > /etc/lightdm/lightdm.conf.d/99-disallow-guest.conf"
fi

