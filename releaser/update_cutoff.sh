#!/bin/bash

echo updating $1
#../merger/msxsl.exe - ../merger/versionrelease.xslt -o $1.new < $1
xsltproc -o $1.new ../merger/versioncutoff.xslt $1
tr -d '\015' <$1.new >$1
rm $1.new
# echo done
