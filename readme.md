# scripts for exporting PUL marc data for POD

n.b., a full dump convereted using these scripts, requires about 15GB of disk space

1. download the most recent full dump from alma into the bibdata directory:

    ```
    ./bibdata.rb
    ```

2. repackage to remove pointless tar wrappers and save xml.gz in unwrapped directory:

    ```
    ./unwrap.sh
    ```

3. remove records without oclc# and strip 583s

    ```
    ./filter.sh
    ```
