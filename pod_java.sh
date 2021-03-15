#!/bin/sh
CP=marc4j-2.9.1.jar
ALMA_DIR="/Users/correah/data/fulldump_expanded"
POD_DIR="/Users/correah/data/pod_files_java"

mkdir -p $POD_DIR
rm $POD_DIR/*.xml

echo compiling...
javac -cp $CP filter.java

if [ $? != 0 ]; then
  exit
fi

for FILE in $ALMA_DIR/*.xml
do
  BASE_NAME=`basename $FILE`
  POD_FILE="$POD_DIR/pod_$BASE_NAME"
  echo "Processing $FILE"

  java -cp $CP:. filter $FILE > $POD_FILE
  # For testing purposes just process one file
  # break
done
