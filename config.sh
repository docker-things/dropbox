#!/bin/bash

# The name of the docker image
PROJECT_NAME="dropbox"

# The path where your files will be
DROPBOX_STORAGE="`pwd`/data/Dropbox"

# Dropbox database & stuff
DROPBOX_DATA="`pwd`/data/.dropbox"

# Dropbox binaries
DROPBOX_DIST="`pwd`/data/.dropbox-dist"

# Create dirs if not exist on launch
if [ "$1" == "start" ]; then
    if [ ! -d "$DROPBOX_STORAGE" ]; then mkdir -p "$DROPBOX_STORAGE"; fi
    if [ ! -d "$DROPBOX_DATA"    ]; then mkdir -p "$DROPBOX_DATA";    fi
    if [ ! -d "$DROPBOX_DIST"    ]; then mkdir -p "$DROPBOX_DIST";    fi
fi

# BUILD ARGS
BUILD_ARGS=(
    --build-arg DOCKER_USERID=$(id -u)
    --build-arg DOCKER_GROUPID=$(id -g)
    --build-arg DOCKER_USERNAME=$(whoami)
    )

# RUN ARGS
RUN_ARGS=(
    -v $DROPBOX_STORAGE:/dbox/Dropbox
    -v $DROPBOX_DATA:/dbox/.dropbox
    -v $DROPBOX_DIST:/dbox/.dropbox-dist

    -p 17500:17500

    --dns="`sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' pi-hole`"

    --memory="1g"
    --cpu-shares=128

    --rm
    -d
    )
