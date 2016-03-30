#!/bin/sh

## got the information from http://cran.rstudio.com/bin/linux/ubuntu/README.html

## add a repository
echo 'deb http://ftp5.gwdg.de/pub/misc/cran//bin/linux/ubuntu trusty/' | sudo tee /etc/apt/sources.list.d/cran.list

gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
gpg -a --export E084DAB9 | sudo apt-key add -

sudo apt-get update
sudo apt-get --assume-yes install r-base r-base-dev
 
