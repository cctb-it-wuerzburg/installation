#!/bin/bash
GROUPNAME=molecularbiodiversity
for i in alk50uw wis26sq s216121
do
  ZFSDATASET=tank/"$GROUPNAME"/home/"$i"
  sudo zfs create -o mountpoint=/new_home/"$i" "$ZFSDATASET"
done

GROUPNAME=supramolecularcellularsimulations
for i in frm73du
do
  ZFSDATASET=tank/"$GROUPNAME"/home/"$i"
  sudo zfs create -o mountpoint=/new_home/"$i" "$ZFSDATASET"
done

GROUPNAME=ecologicalmodeling
for i in s216849 jus15cq
do
  ZFSDATASET=tank/"$GROUPNAME"/home/"$i"
  sudo zfs create -o mountpoint=/new_home/"$i" "$ZFSDATASET"
done

GROUPNAME=evolutionarygenomics
for i in ama42bf ark06eu jaf81qa s2046859
do
  ZFSDATASET=tank/"$GROUPNAME"/home/"$i"
  sudo zfs create -o mountpoint=/new_home/"$i" "$ZFSDATASET"
done

GROUPNAME=computationalimageanalysis
for i in phk57mf top40ub
do
  ZFSDATASET=tank/"$GROUPNAME"/home/"$i"
  sudo zfs create -o mountpoint=/new_home/"$i" "$ZFSDATASET"
done

GROUPNAME=computationalevolutionarybiology
for i in binf009 binf017 binf019 binf033 binf034 chk21hr dak76sx frf53jh heb56qy its2 mal41rx s171333 s187512 s187864 s194335 s195052 s195127 s196670 s200605 s205020 s211854 s211910 s215634 s216017 s216115 s216125 s216155 s217942 s222434 s227942 s227991 s228165 s228711 s229502 s229502_cctb s231779 s319932 s320561 s321065 tek47sn tis55hc
do
  ZFSDATASET=tank/"$GROUPNAME"/home/"$i"
  sudo zfs create -o mountpoint=/new_home/"$i" "$ZFSDATASET"
done
