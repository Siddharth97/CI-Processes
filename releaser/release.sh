#!/bin/bash
YELLOW='\033[1;33m'
NC='\033[0m'

if [ "$#" -ne 4 ]; then
   echo "release.sh current_version release_version next_version jira"
   exit 1
fi

GITORIGIN=($(git config --get remote.origin.url | sed 's,/, ,g'))
REPO_NAME=${GITORIGIN[-1]}
CURRENT_VERSION=$1
RELEASE_VERSION=$2
NEXT_VERSION=$3
BRANCH_NAME="release-$RELEASE_VERSION"
JIRA=$4


echo -e "${YELLOW}[INFO]${NC} REPOSITORY=$REPO_NAME"
echo -e "${YELLOW}[INFO]${NC} VERSION   =$RELEASE_VERSION"
echo -e "${YELLOW}[INFO]${NC} BRANCH    =$BRANCH_NAME"
echo -e "${YELLOW}[INFO]${NC} JIRA      =$JIRA"
echo
echo

echo -e "${YELLOW}[INFO]${NC} Updating local workspace according to $REPO_NAME"
../merger/updater.sh release
echo -e "${YELLOW}[INFO]${NC} Creating $BRANCH_NAME"
../merger/createbranch.sh $BRANCH_NAME
read -rep $'Review Results (10secs to continue)\n' -t 10
echo
echo

echo -e "${YELLOW}[INFO]${NC} Updating from $CURRENT_VERSION to $RELEASE_VERSION"
if [ $REPO_NAME == 'aam-jbpm.git' ]; then
   echo aam-jbpm!
  ../merger/update_version.sh ./pom.xml $CURRENT_VERSION $RELEASE_VERSION
  ../merger/update_version.sh ./AAM/AAM/pom.xml $CURRENT_VERSION $RELEASE_VERSION
  ../merger/update_version.sh ./BBC/BBC/pom.xml $CURRENT_VERSION $RELEASE_VERSION
else
   find . -name "pom*.xml" -exec ../merger/update_version.sh {} $CURRENT_VERSION $RELEASE_VERSION \;
fi
read -rep $'Review Results (10secs to continue)\n' -t 10
echo
echo

echo -e "${YELLOW}[INFO]${NC} Committing changes"
../merger/commitandpush.sh $RELEASE_VERSION $JIRA
if [ $? -ne 0 ]; then
  exit 0
fi
read -rep $'Review Results (10secs to continue)\n' -t 10

echo -e "${YELLOW}[INFO]${NC} Tagging $RELEASE_VERSION"
../merger/tagpush.sh $RELEASE_VERSION
read -rep $'Review Results (10 secs to continue)\n' -t 10
echo

echo -e "${YELLOW}[INFO]${NC} Updating from $RELEASE_VERSION to $NEXT_VERSION"
if [ $REPO_NAME == 'aam-jbpm.git' ]; then
  ../merger/update_version.sh ./pom.xml $RELEASE_VERSION $NEXT_VERSION
  ../merger/update_version.sh ./AAM/AAM/pom.xml $RELEASE_VERSION $NEXT_VERSION
  ../merger/update_version.sh ./BBC/BBC/pom.xml $RELEASE_VERSION $NEXT_VERSION
else
  find . -name "pom*.xml" -exec ../merger/update_version.sh {} $RELEASE_VERSION $NEXT_VERSION \;
fi
read -rep $'Review Results (10 secs to continue)\n' -t 10
echo

echo -e "${YELLOW}[INFO]${NC} Committing changes"
../merger/commitandpush.sh $NEXT_VERSION $JIRA
