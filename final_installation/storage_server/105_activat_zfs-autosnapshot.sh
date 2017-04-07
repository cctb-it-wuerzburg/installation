#!/bin/bash

sudo apt update
sudo apt install --assume-yes software-properties-common

sudo add-apt-repository --yes --update ppa:zfs-native/stable

sudo apt install zfs-auto-snapshot
