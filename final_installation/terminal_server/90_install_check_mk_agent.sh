#!/bin/bash

## install xinetd
sudo apt-get install --assume-yes xinetd

## add the omd repository
gpg --keyserver keys.gnupg.net --recv-keys F8C1CA08A57B9ED7
gpg --armor --export F8C1CA08A57B9ED7 | sudo apt-key add -
echo 'deb http://labs.consol.de/repo/stable/ubuntu trusty main' | sudo tee /etc/apt/sources.list.d/omd-stable.list
sudo apt-get update

# create a directory in the temporary folder
MYTEMPDIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'mytmpdir')

cd "$MYTEMPDIR"

# create a directory for the downloaded agents and packages
mkdir agents packages

for i in $(apt-cache search --names-only omd- | sed 's/^\([^[:space:]*]*\).*/\1/g')
do
    apt-get download "$i"

    # check if the download failed
    if [ $? -eq 0 ]
    then
	# the download passed
	mkdir extract
	dpkg --extract "$i"* extract

	# find all debian packages names agent*.db
	for agent_file in $(find ./extract/ -name "*agent*.deb")
	do
	    VERSION=$(dpkg --info "$agent_file" | grep "Version:" | sed 's/^.*Version:[:space:]*//g')
	    cp "$agent_file" agents/"$VERSION"_$(basename "$agent_file")

	    rm -rf extract
	done

	# move the package file
	mv "$i"* packages/
    else
	echo "Something went wrong while download... Skipping '$i'"
    fi
done

# list the agent versions in reverse order sorted by version numbers
AGENT_2_INSTALL=$(find agents -name "*.deb" | sort -V -r)

# and install the agent finally
sudo dpkg -i "$AGENT_2_INSTALL"

# and remove the temporary folders
cd ~ && rm -rf "$MYTEMPDIR"
