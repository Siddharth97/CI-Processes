#!/bin/bash

if [ "$#" -ne 3 ]; then
   echo "tagpush.sh file version_from version_to"
   exit 1
fi


echo updating $1 from $2 to $3
#../merger/msxsl.exe - ../merger/versionrelease.xslt -o $1.new < $1
xsltproc --stringparam expectedVersion $2 --stringparam targetVersion $3 -o $1.new ../merger/versionupdate.xslt $1
if [ $? -ne 0 ]; then
  echo "something went wrong. exiting"
  exit 1
fi

tr -d '\015' <$1.new >$1
rm $1.new
# echo done
