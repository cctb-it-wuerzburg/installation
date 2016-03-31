#!/bin/bash

### Update all packages
sudo apt-get update
sudo apt-get --assume-yes dist-upgrade

sudo apt-get autoremove --assume-yes

