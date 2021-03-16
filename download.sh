#!/bin/sh

ALMA_DIR="/Users/correah/data/alma_files"

mkdir -p $ALMA_DIR
cd $ALMA_DIR

# Download the files
#
# NOTE: You might want to adjust the wildcard to select a different Alma dump since
# there can be more than one set in the server.
#
scp deploy@bibdata-alma-staging1:/data/marc_liberation_files/fulldump_6423467350006421_20210130_140137*.tar.gz

# ...and uncompress them
for f in *.tar.gz; do tar -xvf "$f"; done
