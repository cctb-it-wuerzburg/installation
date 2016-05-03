#!/bin/bash

# install vegan and ape via cran-repository
for i in r-cran-vegan r-cran-ape
do
  apt install --assume-yes "$i"
done

#R packages
Rscript install_packages.R
#fastQC, seaview
apt install --yes --force-yes fastqc seaview
#qiime
apt install --yes --force-yes build-essential python-dev python-pip libfreetype6-dev
pip install qiime
#figtree
apt install --yes --force-yes figtree

#ea-utils
apt install --assume-yes --no-install-recommends ea-utils

# install optional software (SeqFilter/usearch) via special package
cd /tmp
git clone git@132.187.22.105:alex-summerschool-2016/opt-software
cd opt-software
dpkg -i summerschool-opt-software_1.0.0_amd64.deb
