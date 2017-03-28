#!/bin/bash

for i in $(find -name "[0-9]*.sh" | xargs basename -n1 | sort -n)
do 
    date +"[%Y-%m-%dT%H:%M:%S] Started script '$i'" | tee --append run.log
    ./"$i" 2> "$i".err | tee "$i".log
    date +"[%Y-%m-%dT%H:%M:%S] Finished script '$i'" | tee --append run.log
done
