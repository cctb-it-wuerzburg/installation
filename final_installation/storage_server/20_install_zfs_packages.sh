#!/bin/bash

sudo apt-get --assume-yes install software-properties-gtk

# install ZFS repository

sudo add-apt-repository ppa:zfs-native/stable

# install ZFS package

sudo apt-get install ubuntu-zfs

