#!/bin/sh
PATH=$PATH:/home/builduser/syncthing
# 
rm -rf "/root/.config/syncthing/index-v0.14.0.db"
# 
STTRACE=fs scanner walk walkfs
#
./syncthing
