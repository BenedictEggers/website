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
# |   |-- sub1
# |   |   |
# |   |   |-- file1.hash
# |   |   |-- file2.hash
# |   |
# |   |-- sub2
# |   |   |
# |   |   |-- file3.hash
# |   |   |-- sub3
# |   |   |   |
# |   |   |   |-- file4.hash
#
#
# You MUST make sure that the source and destination do not contain each other.
# No promises on what happens in that case.
