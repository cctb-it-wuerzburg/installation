#!/bin/bash

# Skype installation
wget -O - 'http://www.skype.com/go/getskype-linux-beta-ubuntu-64' > /tmp/skype.deb
sudo dpkg --install /tmp/skype.deb
sudo apt-get --assume-yes install -f

