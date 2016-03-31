#!/bin/sh

wget -O - 'http://www.mendeley.com/repositories/ubuntu/stable/amd64/mendeleydesktop-latest' > /tmp/mendeley.deb

sudo dpkg --install /tmp/mendeley.deb

sudo apt-get --assume-yes install -f
