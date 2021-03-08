ALMA_DIR="/Users/correah/data/fulldump_expanded"
POD_DIR="./pod_files_ruby"

mkdir -p $POD_DIR
rm "$POD_DIR/*"

for FILE in $ALMA_DIR/*.xml
do
    ruby filter.rb $FILE
    # For testing purposes just process one file
    break
done

