#!/bin/bash

sudo apt update
sudo apt install --assume-yes software-properties-common

sudo add-apt-repository --yes --update ppa:bob-ziuchkovski/zfs-auto-snapshot

sudo apt install zfs-auto-snapshot
