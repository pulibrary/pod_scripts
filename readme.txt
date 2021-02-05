# scripts for exporting PUL marc data for POD

1. download the most recent full dump from alma into the bibdata directory:

./bibdata.rb

2. repackage to remove pointless tar wrappers and save xml.gz in unwrapped directory:

./unwrap.sh

3. remove records without oclc# and strip 583s

./filter.sh
