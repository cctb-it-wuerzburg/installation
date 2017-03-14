#!/bin/bash

# Information taken from http://wiki.x2go.org/doku.php/doc:installation:x2goserver on 2107-03-14

sudo apt-get install --assume-yes software-properties-common

sudo add-apt-repository --yes ppa:x2go/stable
sudo apt-get update
sudo apt-get install --assume-yes x2goserver x2goserver-xsession
