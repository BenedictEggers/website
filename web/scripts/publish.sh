#!/bin/bash

# This script will rebuild the site and push it to the server.

SERVER_ADDR="104.131.80.184"
BASE_DIR="${HOME}/Documents/projects/website/web"


# Remake the site
cd ${BASE_DIR}
ghc --make -threaded site.hs
./site rebuild


# Remake the hashes
./scripts/gen_hashes.sh _site hashes/
ssh root@${SERVER_ADDR} '~/gen_hashes.sh /var/www/html ~/hashes'


# Get the remote hashes
scp -r root@${SERVER_ADDR}:~/hashes remote_hashes/

scp -r _site/* root@${SERVER_ADDR}:/var/www/html/
