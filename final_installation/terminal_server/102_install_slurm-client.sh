#!/bin/bash

# correct /var/log permissions
sudo chmod g-w /var/log

sudo apt update

sudo apt install --assume-yes munge

sudo apt install --assume-yes slurm-client

# get the correct munge key, therefore the base64 encoded string can be used
echo "Please enter the base64 encoded munge file followed by a empty line and ctrl-d"

sudo bash -c 'base64 --decode > /etc/munge/munge.key'

# get the correct slurm.conf file
sudo scp cctbadmin@slurmmaster:/etc/slurm-llnl/slurm.conf /etc/slurm-llnl/
sudo chown slurm.slurm /etc/slurm-llnl/slurm.conf

sudo service munge restart
