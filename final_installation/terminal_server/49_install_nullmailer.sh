#!/bin/bash

### set default values for our university

echo "
nullmailer    shared/mailname    string    $HOSTNAME.biologie.uni-wuerzburg.de
nullmailer    nullmailer/defaultdomain    string    uni-wuerzburg.de
nullmailer    nullmailer/relayhost    string    mailmaster.uni-wuerzburg.de
nullmailer    nullmailer/adminaddr    string   cctb-it@lists.uni-wuerzburg.de
" | sudo debconf-set-selections

sudo apt install --assume-yes nullmailer

# send a test email
