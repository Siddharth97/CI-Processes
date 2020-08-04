#!/bin/bash

if [ -z "$1" ]; then
   echo "branch name missing"
   exit 1
fi

BRANCH=$1

echo "updading metadata"
git fetch -p
git pull

#WHEREAMI=$(git branch | grep \* | tr -d '* ')
#echo "I'm at $WHEREAMI"

#if [ ! "$WHEREAMI"=="release" ]; then
#    echo "not are in release, switching"
#    git checkout release
#fi

#git checkout release

BRANCHEXISTS=$(git branch | grep "$BRANCH")
echo "Branch exists? $BRANCHEXISTS"
if [ -z "$BRANCHEXISTS" ]; then
    echo "creating branch $1 locally from $WHEREAMI"
    git checkout -b $1

    echo "creating branch $1 remotely"
    git push -u origin $BRANCH
else
    echo "branch exists!"
    echo "switching to $BRANCH"
    git checkout $BRANCH
fi
