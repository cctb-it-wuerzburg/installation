#!/bin/bash

# try to create a new pool

sudo zpool create tank \
	-o autoexpand=on \
	-O compression=lz4 \
	raidz2 \
		/dev/disk/by-id/ata-ST4000VX000-1F4168_Z305ZDNB \
                /dev/disk/by-id/ata-ST4000VX000-1F4168_Z305ZKAC \
                /dev/disk/by-id/ata-ST4000VX000-1F4168_Z305YRLK \
                /dev/disk/by-id/ata-ST4000VX000-1F4168_Z305ZE55 \
                /dev/disk/by-id/ata-ST4000VX000-1F4168_Z305ZJ0P \
                /dev/disk/by-id/ata-ST4000VX000-1F4168_Z305ZB5B \
	raidz2 \
                /dev/disk/by-id/ata-ST4000VX000-1F4168_Z305ZGB4 \
                /dev/disk/by-id/ata-ST4000VX000-1F4168_Z305ZW0V \
                /dev/disk/by-id/ata-ST4000VX000-1F4168_Z305ZAT6 \
                /dev/disk/by-id/ata-ST4000VX000-1F4168_Z305ZA6Y \
                /dev/disk/by-id/ata-ST4000VX000-1F4168_Z30604KV \
                /dev/disk/by-id/ata-ST4000VX000-1F4168_Z305ZK6E


for group in computational_evolutionary_biology computational_image_analysis ecological_modeling evolutionary_genomics supramolecular_and_cellular_simulations molecular_biodiversity
do
	zfs create tank/"$group"
	zfs create tank/"$group"/home
	zfs create tank/"$group"/storage
done

zfs create tank/scratch


