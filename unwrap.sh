#!/bin/sh

# dump from alma has each marcxml file in its own tar.gz archive.
# this script removes the pointless tar wrapper and re-gzips them

cd unwrapped
rm -f *.gz
for i in ../bibdata/*.tar.gz; do
  BASE=`basename $i .tar.gz`
  tar Oxvfz $i | gzip -c > $BASE.xml.gz
done
