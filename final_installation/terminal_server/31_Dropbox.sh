#!/bin/bash

# Dropbox installation
wget -O - 'https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_1.6.0_amd64.deb' > /tmp/dropbox.deb
sudo dpkg --install /tmp/dropbox.deb
sudo apt-get --assume-yes install -f
