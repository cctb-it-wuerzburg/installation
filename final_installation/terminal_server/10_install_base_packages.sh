#!/bin/bash

PACKAGES=$(cat package.list | grep -v "^#")

sudo apt-get --assume-yes install $PACKAGES
