#!/bin/bash

for i in [0-9]*.sh
do 
    date +"[%Y-%m-%dT%H:%M:%S] Started script '$i'" | tee --append run.log
    ./"$i" 2> "$i".err | tee "$i".log
    date +"[%Y-%m-%dT%H:%M:%S] Finished script '$i'" | tee --append run.log
done
