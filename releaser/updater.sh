#!/bin/bash
git fetch -p

FIRST=$1
if [ -z "$1" ]; then
  FIRST="develop"
fi
git checkout $FIRST
git pull
git status
