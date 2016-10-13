#!/bin/bash

## Add HP Management Component Pack Mirror
echo "deb http://downloads.linux.hpe.com/SDR/downloads/MCP/ubuntu xenial non-free" | sudo tee /etc/apt/sources.list.d/hpmcp.sources.list

wget -O - 'http://downloads.linux.hpe.com/SDR/repo/mcp/GPG-KEY-mcp' | sudo apt-key add -

sudo apt-get update

sudo apt-get install --assume-yes \
    hp-health \
    hp-snmp-agents

# for safety reason
sudo mkdir -p /etc/snmp

if [ -e /etc/snmp/snmpd.conf ]
then
    mv /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf.old
fi

echo "dlmod cmaX /usr/lib/libcmaX64.so
rwcommunity private 127.0.0.1/32
rocommunity public 127.0.0.1/32
rwcommunity private 132.187.22.169/32
rocommunity public 132.187.22.169/32
trapcommunity private
trapsink 132.187.22.169/32 private" | sudo tee /etc/snmp/snmpd.conf

for i in hp-health hp-snmp-agents snmpd
do
    sudo service "$i" restart
done
