#!/bin/bash

# This script takes two arguments: a source directory, and a destination directory.
# It creates a copy of the source folder's structure inside the destination folder,
# with files replaced by hashes of those files. I.e. if you had this:
#
# base/
# |
# |-- source/
# |   |
# |   |-- sub1
# |   |   |
# |   |   |-- file1.somehing
# |   |   |-- file2.whatever
# |   |
# |   |-- sub2
# |   |   |
# |   |   |-- file3.otherThing
# |   |   |-- sub3
# |   |   |   |
# |   |   |   |-- file4.whoCares
# |
# |-- dest/
#
#
# and you ran ```./gen_hashes.sh base/ dest/```, you would get:
#
#
# base/
# |
# |-- source/
# |   |
# |   |-- sub1
# |   |   |
# |   |   |-- file1.somehing
# |   |   |-- file2.whatever
# |   |
# |   |-- sub2
# |   |   |
# |   |   |-- file3.otherThing
# |   |   |-- sub3
# |   |   |   |
# |   |   |   |-- file4.whoCares
# |
# |-- dest/
# |   |
# |   |-- source/
# |   |   |
# |   |   |-- sub1
# |   |   |   |
# |   |   |   |-- file1.something.hash
# |   |   |   |-- file2.whatever.hash
# |   |   |
# |   |   |-- sub2
# |   |   |   |
# |   |   |   |-- file3.otherThing.hash
# |   |   |   |-- sub3
# |   |   |   |   |
# |   |   |   |   |-- file4.whoCares.hash
#
#
# You MUST make sure that the source and destination do not contain each other.
# No promises on what happens in that case.

if [[ $# -ne 2 ]]; then
        echo "Usage: ./gen_hashes.sh <source> <dest>"
fi

mkdir -p $2

for THING in $( ls $1 ); do
        if [[ -d $1/$THING ]]; then
                # directory
                ./$0 $1/$THING $2/$THING

        elif [[ -f $1/$THING ]]; then
                # file
                md5sum $1/$THING > $2/$THING.hash
        else
                # ????
                echo "Error processing ${THING}, quitting"
                exit 3
        fi
done
