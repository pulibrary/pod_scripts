# Scripts for exporting PUL marc data for POD
Processes MARC full dumps from Alma and creates MARC files that we can upload to POD.

These scripts assume the MARC files have been downloaded and expanded and that they are in MARC XML format.

There are about 113 MARC files in a full dump.

Some timing information from my local machine:
* ~25 minutes to produce the new MARC files with the Java version of the code.
* ~10 minutes to compress the files.
* ~3 hours to upload the files to POD.


# Workflow

Download MARC dump files produced by Alma and uncompress them:

```
./download.sh
```


Generate the MARC files for POD (removes private notes and only include records with OCLC numbers)

```
./pod_java.sh
```


Compress and upload the files to POD

```
./upload.sh
```


# Code

We tested three different ways of processing our MARC files: one in Ruby, one in Java, and one using a Go library.

## Ruby version
The Ruby version lives is in `filter.rb`. This version takes about 8 minutes per file. This version relies on the `marc` gem.

To test it update `pod_ruby.sh` with the location of the source MARC files and run it. The resulting files will be under `./pod_files_ruby/`

```
$ ./pod_ruby.sh
```


## Java version
The Java version lives in `filter.java` and it takes a few seconds (~10) per file. This version uses the MARC processsing classes provided by `marc4j-2.9.1.jar`.

To test it update `pod_java.sh` with the location of the source MARC files and run it. The resulting files will be under `./pod_files_java/`

```
$ ./pod_java.sh
```


## Go version
The Go version lives in `pod_go.sh` and it takes about 40 seconds per file. The functionality to process the MARC files is provided via the `marcli` executable which is written in Go.

To test it update `pod_go.sh` with the location of the source MARC files and run it. The first time you run it you'll need to download the `marcli` utility, see instructions in the script. The resulting files will be under `./pod_files_go/`

```
$ ./pod_go.sh
```
