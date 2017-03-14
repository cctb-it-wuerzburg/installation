#!/bin/bash

# Commands are taken from https://store.docker.com/editions/community/docker-ce-server-ubuntu?tab=description at 2017-03-14

sudo apt-get -y install \
  apt-transport-https \
  ca-certificates \
  python-software-properties \
  curl

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"
       
sudo apt-get update

sudo apt-get -y install docker-ce
