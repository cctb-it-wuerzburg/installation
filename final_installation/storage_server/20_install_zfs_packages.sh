#!/bin/bash

sudo apt-get --assume-yes install software-properties-gtk

# install ZFS repository

sudo add-apt-repository --yes ppa:zfs-native/stable

sudo apt-get update

# install ZFS package

sudo apt-get --assume-yes install ubuntu-zfs

