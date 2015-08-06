#!/bin/bash

# This script will rebuild the site and push it to the server.

SERVER_ADDR="104.131.80.184"
BASE_DIR="${HOME}/Documents/projects/website/web"
SITE_DIR="_site"
SERVER_BASE_DIR="/var/www/html"


# Remake the site
cd ${BASE_DIR}
ghc --make -threaded site.hs
./site rebuild


# Mount the remote site
MOUNT_DIR=$(mktemp -d)
sshfs -o IdentityFile=/home/ben/.ssh/id_rsa root@${SERVER_ADDR}:${SERVER_BASE_DIR} ${MOUNT_DIR}


# Find differences and fix them
diff -r ${SITE_DIR} ${MOUNT_DIR} | while read LINE; do
        if [[ $LINE == diff* ]]; then
                # Two files differ--copy the _site/ one to ${MOUNT_DIR}
                WORDS=($LINE)
                cp ${WORDS[2]} ${WORDS[3]}

        elif [[ $LINE == Only* ]]; then
                # We need to either add a file to the server, or delete one from it
                WORDS=($LINE)

                if [[ ${WORDS[2]} == $SITE_DIR* ]]; then
                        # Need to add the file to the server
                        TRUNC=${WORDS[2]:0:-1}
                        cp ${TRUNC}/${WORDS[3]} ${MOUNT_DIR}/${TRUNC#*/}/${WORDS[3]}

                elif [[ ${WORDS[2]} == $MOUNT_DIR* ]]; then
                        # Need to delete the file from the server
                        rm ${WORDS[2]:0:-1}/${WORDS[3]}

                else
                        echo "Something is horrible broken with $LINE"
                fi
        fi
done


# Unmount the server, and delete the directory
fusermount -u ${MOUNT_DIR}
rmdir ${MOUNT_DIR}
