#!/bin/sh

POD_DIR="/Users/correah/data/pod_files_java"
MIME_TYPE="application/marcxml+xml"
API_KEY="indicate-your-pod-key-here"

# Compress the MARC XML files...
for FILE in $POD_DIR/*.xml
do
    echo "Compressing $FILE"
    gzip $FILE
done

# ... and upload them to POD
for FILE in $POD_DIR/*.xml.gz
do
    echo "Uploading $FILE"
    curl -F "upload[files][]=@$FILE;type=$MIME_TYPE" \
        -H "Authorization: Bearer $API_KEY" \
        https://pod.stanford.edu/organizations/princeton/uploads
done

echo "Done"
