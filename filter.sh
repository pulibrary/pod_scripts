#!/bin/sh

CP=marc4j-2.9.1.jar

echo compiling...
javac -cp $CP filter.java 
if [ $? = 0 ]; then
  echo removing output files...
  rm -rf filtered/*

  java -cp $CP:. filter xml/*
fi
