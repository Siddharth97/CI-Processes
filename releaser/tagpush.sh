#!/bin/bash

if [ -z "$1" ]; then
   echo "tagpush.sh version"
   exit 1
fi

VERSION=$1
TAG="v$VERSION"
#AUTOACCMON-6415

TAGGED=$(git tag -l $TAG)
if [ -z "$TAGGED" ]; then
    git tag v$VERSION
    git push origin v$VERSION
else
    echo "tag $TAG already exists: $TAGGED"
fi
