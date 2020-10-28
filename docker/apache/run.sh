#!/usr/bin/bash
set -e
docker run -dit -p 8081:80 --name ubapache troi.fritz.box/ubapache:latest
