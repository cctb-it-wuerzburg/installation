#!/bin/bash

# Slack installation
wget -O /tmp/slack.deb 'https://downloads.slack-edge.com/linux_releases/slack-desktop-2.5.2-amd64.deb'
sudo dpkg --install /tmp/slack.deb
sudo apt-get --assume-yes install -f

