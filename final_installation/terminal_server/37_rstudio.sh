#!/bin/sh

## download rstudio in latest version

LATEST=$(wget -O - -q http://www.rstudio.com/products/rstudio/download/ | grep "Ubuntu" | grep "64-bit" | grep "\.deb" | sed 's/^.*<a href="\(.*\)">\(RStudio [0-9.]*\).*/\2;\1/')

#IFS=';' read RSTUDIOVERSION RSTUDIOLINK <<<"$(echo $LATEST)"

RSTUDIOVERSION=$(echo "$LATEST" | cut -f 1 -d ";")
RSTUDIOLINK=$(echo "$LATEST" | cut -f 2 -d ";")

echo "Downloading $RSTUDIOVERSION..."

wget -O - "$RSTUDIOLINK" > /tmp/rstudio.deb

sudo dpkg --install /tmp/rstudio.deb
sudo apt-get --assume-yes install -f
