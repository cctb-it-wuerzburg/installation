#!/bin/bash

sudo apt update
sudo apt install software-properties-common

sudo add-apt-repository ppa:zfs-native/stable
sudo apt update

sudo apt install zfs-auto-snapshot
