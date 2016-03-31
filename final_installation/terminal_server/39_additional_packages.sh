#!/bin/bash

## This is obtained from http://howtoubuntu.org/things-to-do-after-installing-ubuntu-14-04-trusty-tahr#install-essentials

## Enable Partner Repositories
sed -i '/^# deb.*partner/s/^#[[:space:]]*//g' sources.list

echo "Downloading GetDeb and PlayDeb" &&
wget http://archive.getdeb.net/install_deb/getdeb-repository_0.1-1~getdeb1_all.deb http://archive.getdeb.net/install_deb/playdeb_0.3-1~getdeb1_all.deb &&

echo "Installing GetDeb" &&
sudo dpkg -i getdeb-repository_0.1-1~getdeb1_all.deb &&

echo "Installing PlayDeb" &&
sudo dpkg -i playdeb_0.3-1~getdeb1_all.deb &&

echo "Deleting Downloads" &&
rm -f getdeb-repository_0.1-1~getdeb1_all.deb &&
rm -f playdeb_0.3-1~getdeb1_all.deb

sudo add-apt-repository -y ppa:videolan/stable-daily

sudo add-apt-repository -y ppa:otto-kesselgulasch/gimp

sudo add-apt-repository -y ppa:gnome3-team/gnome3

sudo add-apt-repository -y ppa:webupd8team/java

# Accepting the JAVA license per default
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections

sudo add-apt-repository -y ppa:webupd8team/y-ppa-manager

echo 'deb http://download.videolan.org/pub/debian/stable/ /' | sudo tee /etc/apt/sources.list.d/libdvdcss.list &&
echo 'deb-src http://download.videolan.org/pub/debian/stable/ /' | sudo tee -a /etc/apt/sources.list.d/libdvdcss.list &&
wget -O - http://download.videolan.org/pub/debian/videolan-apt.asc|sudo apt-key add -

sudo apt-get update

sudo apt-get --assume-yes upgrade

sudo apt-get --assume-yes dist-upgrade

PACKAGES=$(cat additional.packages.list | grep -v "^#")

sudo apt-get --assume-yes install $PACKAGES

echo "Cleaning Up" &&
sudo apt-get -f install &&
sudo apt-get autoremove &&
sudo apt-get -y autoclean &&
sudo apt-get -y clean
