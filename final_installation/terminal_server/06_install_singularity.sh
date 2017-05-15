#!/bin/bash

#Install Singularity from development Branch, bcause in Master Branch is a Bug (12.05.2017)

#sudo git clone -b development https://github.com/singularityware/singularity.git

sudo wget https://github.com/singularityware/singularity/archive/development.zip

sudo unzip development.zip

cd singularity-development

sudo ./autogen.sh

sudo ./configure --prefix=/usr/local --sysconfdir=/etc

sudo make

sudo make install

cd ..


# Remove install data
sudo rm development.zip 
sudo rm -rf singularity-development 
