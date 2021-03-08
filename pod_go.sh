#!/bin/bash

# Download marcli for Mac
# curl -L https://github.com/hectorcorrea/marcli/releases/download/1.0.1/marcli > marcli
#
# Download marcli for Linux
# curl -L https://github.com/hectorcorrea/marcli/releases/download/1.0.1/marcli_linux > marcli
#
# Make it executable
# chmod u+x marcli

ALMA_DIR="/Users/correah/data/fulldump_expanded"
POD_DIR="./pod_files_go"

mkdir -p $POD_DIR
rm "$POD_DIR/*"

for FILE in $ALMA_DIR/*.xml
do
    BASE_NAME=`basename $FILE`
    POD_FILE="$POD_DIR/pod_$BASE_NAME"
    echo "Processing $BASE_NAME"

    # Export
    #   Only records with a 035 field
    #   That have the word "OCoLC" (somewhere on the record)
    # Exclude field 583 (private notes for RBSC items) from the output
    # Output as XML (nicely formated via debug=true)
    ./marcli -file=$FILE -hasFields=035 -match=OCoLC -exclude=583 -format=xml -debug=true > $POD_FILE

    # For testing purposes just process one file
    break
done
