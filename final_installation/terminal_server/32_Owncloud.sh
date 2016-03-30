#!/bin/bash

# Owncloud installation
wget -q -O - http://download.opensuse.org/repositories/isv:ownCloud:desktop/Ubuntu_14.04/Release.key | sudo apt-key add -

sudo sh -c "echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/Ubuntu_14.04/ /' > /etc/apt/sources.list.d/owncloud-client.list"
sudo apt-get update
sudo apt-get --assume-yes install owncloud-client
