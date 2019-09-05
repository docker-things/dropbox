#!/bin/bash

# Command used to launch docker
DOCKER_CMD="`which docker`"

# Where to store the backups
BACKUP_PATH=""

# Where to store the communication pipes
FIFO_PATH="/tmp/docker-things/fifo"

# The name of the docker image
PROJECT_NAME="dropbox"

# BUILD ARGS
BUILD_ARGS=(
    --build-arg DOCKER_USERID=$(id -u)
    --build-arg DOCKER_GROUPID=$(id -g)
    --build-arg DOCKER_USERNAME=$(whoami)
    )

# RUN ARGS
RUN_ARGS=(

    # The path where your files will be
    -v $(pwd)/data/Dropbox:/dbox/Dropbox

    # Dropbox database & stuff
    -v $(pwd)/data/.dropbox:/dbox/.dropbox

    # Dropbox binaries
    -v $(pwd)/data/.dropbox-dist:/dbox/.dropbox-dist

    -p 17500:17500

    # --dns="`sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' pi-hole`"

    --memory="1g"
    --cpu-shares=128

    --rm
    -d
    )
