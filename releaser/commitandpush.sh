#!/bin/bash

if [ -z "$1" ]; then
   echo "version"
   exit 1
fi
if [ -z "$2" ]; then
   echo "jira ticket!"
   exit 1
fi

VERSION=$1
JIRA=$2
#AUTOACCMON-6415

git status
git diff

read -p "Commit [y/n]? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    git add -u
    git status
    git commit -m "$JIRA: $VERSION"
    git push
else
  exit 1
fi
