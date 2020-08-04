#!/bin/bash
git checkout release
git pull
git checkout develop
git pull
git merge release
