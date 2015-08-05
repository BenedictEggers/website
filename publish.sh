#!/bin/bash

# This script will rebuild the site and push it to the server.

SERVER_ADDR="192.241.238.108"

ghc --make -threaded site.hs
./site rebuild
scp -r _site/* root@${SERVER_ADDR}:/var/www/html/    # praise SSH keys
