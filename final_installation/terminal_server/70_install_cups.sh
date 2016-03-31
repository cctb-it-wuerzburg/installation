#!/bin/bash

sudo service cups stop
rm -rf /etc/cups/*
sudo tar -xf $PWD/cups.tar.bz2 -C /etc/
sudo service cups start
