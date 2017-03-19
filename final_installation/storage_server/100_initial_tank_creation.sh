#!/bin/bash

zpool create \
        -o autoexpand=on \
        -o ashift=12 \
        -O compression=lz4 \
        tank \
        raidz2 \
                /dev/disk/by-id/ata-HGST_HDS724040ALE640_PK2331PAHP44HT \
                /dev/disk/by-id/ata-HGST_HDS724040ALE640_PK1331PAHR7UGS \
                /dev/disk/by-id/ata-HGST_HDS724040ALE640_PK1331PAHN7PTS \
                /dev/disk/by-id/ata-HGST_HDS724040ALE640_PK1331PAHR4VRS \
        raidz2 \
                /dev/disk/by-id/ata-HGST_HDS724040ALE640_PK1331PAHM8Z8S \
                /dev/disk/by-id/ata-HGST_HDS724040ALE640_PK1331PAHPE4US \
                /dev/disk/by-id/ata-HGST_HDS724040ALE640_PK1331PAHMA04S \
                /dev/disk/by-id/ata-HGST_HDS724040ALE640_PK1331PAH9VYBS \
        raidz2 \
                /dev/disk/by-id/ata-HGST_HDS724040ALE640_PK2331PAHPR8ST \
                /dev/disk/by-id/ata-Hitachi_HDS724040ALE640_PK2331PAGR09YT \
                /dev/disk/by-id/ata-HGT_HDS724040ALE640_PK2331PAHP23LT \
                /dev/disk/by-id/ata-HGST_HDS724040ALE640_PK1331PAHPMX7S \
        raidz2 \
                /dev/disk/by-id/ata-HGST_HDS724040ALE640_PK1331PAHNTY9S \
                /dev/disk/by-id/ata-Hitachi_HDS724040ALE640_PK2331PAGPUP4T \
                /dev/disk/by-id/ata-HGST_HDS724040ALE640_PK2331PAJG3ALW \
                /dev/disk/by-id/ata-HGST_HDS724040ALE640_PK1301PAHS08ZS \
        raidz2 \
                /dev/disk/by-id/ata-HGST_HDS724040ALE640_PK1331PAHM2BZS \
                /dev/disk/by-id/ata-HGST_HDS724040ALE640_PK2331PAHL5MVT \
                /dev/disk/by-id/ata-HGST_HDS724040ALE640_PK2301PAHNBRUT \
                /dev/disk/by-id/ata-HGST_HDS724040ALE640_PK1301PAHKPDSS \
        raidz2 \
                /dev/disk/by-id/ata-HGST_HDS724040ALE640_PK1301PAHJNDSS \
                /dev/disk/by-id/ata-HGST_HDS724040ALE640_PK1301PAHNS8HS \
                /dev/disk/by-id/ata-Hitachi_HDS724040ALE640_PK2331PAGR04AT \
                /dev/disk/by-id/ata-Hitachi_HDS724040ALE640_PK2331PAGR6V2T \
        raidz2 \
                /dev/disk/by-id/ata-HGST_HDS724040ALE640_PK1301PAHRARBS \
                /dev/disk/by-id/ata-Hitachi_HDS724040ALE640_PK2331PAGPRART \
                /dev/disk/by-id/ata-HGST_HDS724040ALE640_PK1311PAHNU58S \
                /dev/disk/by-id/ata-HGST_HDS724040ALE640_PK2331PAHNH2GT \
        raidz2 \
                /dev/disk/by-id/ata-HGST_HDS724040ALE640_PK1301PAHLPPSS \
                /dev/disk/by-id/ata-Hitachi_HDS724040ALE640_PK1331PAGPE0BS \
                /dev/disk/by-id/ata-HGST_HDS724040ALE640_PK1301PAHMM8MS \
                /dev/disk/by-id/ata-HGST_HDS724040ALE640_PK2331PAJERKNT
