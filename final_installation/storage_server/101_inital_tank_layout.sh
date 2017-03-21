#!/bin/bash

declare -A groups

groups["computationalevolutionarybiology"]=4000
groups["evolutionarygenomics"]=5000
groups["computationalimageanalysis"]=6000
groups["ecologicalmodeling"]=7000
groups["supramolecularcellularsimulations"]=8000
groups["molecularbiodiversity"]=9000

for groupname in "${!groups[@]}";
do
	zfs create tank/"$groupname"
	zfs create tank/"$groupname"/home
	zfs create tank/"$groupname"/storage

	chgrp ${groups[$groupname]} -R /tank/"$groupname"

	chmod g+s -R /tank/"$groupname"/storage
done
