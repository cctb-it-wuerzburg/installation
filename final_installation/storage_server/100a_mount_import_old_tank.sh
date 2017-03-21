#!/bin/bash

mkdir -p /storage.old
mkdir -p /shelf.old

mount /dev/sda1 /storage.old
mount /dev/sdb1 /shelf.old

zpool import -f -d /storage.old/zfs-files/ -d /shelf.old/zfs-files2/ tank
