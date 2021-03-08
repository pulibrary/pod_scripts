#!/bin/sh
CP=marc4j-2.9.1.jar
ALMA_DIR="/Users/correah/data/fulldump_expanded"
POD_DIR="./pod_files_java"

mkdir -p $POD_DIR
rm "$POD_DIR/*"

echo compiling...
javac -cp $CP filter.java

if [ $? != 0 ]; then
  exit
fi

for FILE in $ALMA_DIR/*.xml
do
  java -cp $CP:. filter $FILE
  # For testing purposes just process one file
  break
done
