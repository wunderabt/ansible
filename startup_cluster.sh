#!/bin/bash

# fileserver first
for host in bc:ae:c5:27:2f:09 90:e6:ba:60:2d:63 20:cf:30:79:06:0a
do
    wakeonlan $host
    sleep 5
done
