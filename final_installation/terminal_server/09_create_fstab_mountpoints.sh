#!/bin/bash

sudo mkdir -p /home
sudo mkdir -p /storage
sudo mkdir -p /old_storage

sudo sed -i '/^### BEGIN added by 09_create_fstab_mountpoints.sh/,/^### END added by 09_create_fstab_mountpoints.sh/d' /etc/fstab

cat <<EOF | sudo tee --append /etc/fstab
### BEGIN added by 09_create_fstab_mountpoints.sh
132.187.198.10:/new_home                     /home        nfs           auto,sync,rw,nosuid,soft,timeo=300,intr 0 0
132.187.198.10:/new_storage                  /storage     nfs           auto,sync,rw,nosuid,soft,timeo=300,intr 0 0
132.187.198.10:/backup_tank/old_storage      /old_storage nfs           auto,sync,ro,nosuid,soft,timeo=300,intr 0 0
### END added by 09_create_fstab_mountpoints.sh
EOF

sudo mount -a
