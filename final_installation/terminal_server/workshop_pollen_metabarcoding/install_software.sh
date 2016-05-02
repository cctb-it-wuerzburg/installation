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

#wget www.drive5.com/uclust/uclustq1.2.22_i86linux32
#mv uclustq1.2.22_i86linux32 /usr/local/bin/uclust
#chmod +x /usr/local/bin/uclust
#raxml
#git clone https://github.com/stamatak/standard-RAxML.git
#cd standard-RAxML
#make -f Makefile.PTHREADS.gcc
#rm *.o
#cd ..
#chmod 755 standard-RAxML/raxmlHPC-PTHREADS
#ln -fs $PWD/standard-RAxML/raxmlHPC-PTHREADS /usr/local/bin/raxml
#Usearch
#chmod 755 $PWD/usearch8.0.1623_i86linux32
#ln -fs $PWD/usearch8.0.1623_i86linux32 /usr/local/bin/usearch
