#!/bin/bash

HOSTS_CONTENT=$(cat <<EOF
132.187.198.10 storage cctbstorage
132.187.198.11 gaia1
132.187.198.12 gaia2
132.187.198.13 saturn1
132.187.198.14 saturn2
132.187.198.15 jupiter
132.187.198.16 venus1
132.187.198.17 gaia3
132.187.198.18 gaia4
132.187.198.19 venus2
132.187.198.20 uranus1
132.187.198.21 uranus3
132.187.198.22 neptun1
132.187.198.23 uranus2
132.187.198.24 merkur1
132.187.198.25 merkur2
EOF
)

# extract own hostname
OWN_HOSTNAME=$(echo "$HOSTS_CONTENT" | grep -P $(ifconfig -a | grep -P "inet\s\S+:[0-9.]+" | sed 's/^.*inet[[:space:]]*[^[:space:]]*:\([0-9.]*\).*/\1/g' | grep -v "127.0.0.1" | tr "\n" "|" | sed 's/|$//') | cut -f 2 -d " ")

if [ -z $OWN_HOSTNAME ]
then
    echo "Own hostname could not be determined!"
    exit 1
fi

echo "$HOSTS_CONTENT" | sudo tee /etc/hosts

sudo sed -i 's/\(127.0.0.1.*\)/\1 '$OWN_HOSTNAME'/' /etc/hosts
sudo hostnamectl set-hostname "$OWN_HOSTNAME"
