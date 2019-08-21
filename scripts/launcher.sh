#!/bin/bash

# Install Dropbox
if [ "`ls -lah .dropbox-dist | wc -l`" == "3" ]; then
    echo -e "\n > Installing Dropbox...\n"
    wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -

    # Check install
    if [ ! -f .dropbox-dist/dropboxd ]; then
        echo -e "\n > ERROR: \".dropbox-dist/dropboxd\" not found!\n"
        exit 1
    fi
fi

#  Dropbox did not shutdown properly? Remove files.
[ ! -e ".dropbox/command_socket" ] || rm .dropbox/command_socket
[ ! -e ".dropbox/iface_socket" ]   || rm .dropbox/iface_socket
[ ! -e ".dropbox/unlink.db" ]      || rm .dropbox/unlink.db
[ ! -e ".dropbox/dropbox.pid" ]    || rm .dropbox/dropbox.pid

# Launch
echo -e "\n > Starting dropboxd ($(cat .dropbox-dist/VERSION))...\n"
exec .dropbox-dist/dropboxd
