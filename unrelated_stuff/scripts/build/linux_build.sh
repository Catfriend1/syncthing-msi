#!/bin/sh
PATH=$PATH:/home/builduser/syncthing-android-prereq/go_1.13.9/bin
go run build.go -version v1.4.1-symlink -no-upgrade -goos linux -goarch amd64 build syncthing

