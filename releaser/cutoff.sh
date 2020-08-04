#!/bin/bash
YELLOW='\033[1;33m'
NC='\033[0m'

if [ "$#" -ne 3 ]; then
   echo "cutoff.sh current_version next_version jira"
   exit 1
fi

GITORIGIN=($(git config --get remote.origin.url | sed 's,/, ,g'))
REPO_NAME=${GITORIGIN[-1]}
CURRENT_VERSION=$1
NEXT_VERSION=$2
JIRA=$3
BRANCH_NAME="feature/$JIRA"


echo -e "${YELLOW}[INFO]${NC} REPOSITORY      = $REPO_NAME"
echo -e "${YELLOW}[INFO]${NC} CURRENT VERSION = $CURRENT_VERSION"
echo -e "${YELLOW}[INFO]${NC} NEXT VERSION    = $NEXT_VERSION"
echo -e "${YELLOW}[INFO]${NC} BRANCH          = $BRANCH_NAME"
echo -e "${YELLOW}[INFO]${NC} JIRA            = $JIRA"
echo

echo -e "${YELLOW}[INFO]${NC} Updating local workspace according to $REPO_NAME - Switching to ${YELLOW}develop${NC} branch"
../merger/updater.sh develop
read -rep $'Review Results (10 secs to continue)\n' -t 10
echo

echo -e "${YELLOW}[INFO]${NC} Creating $BRANCH_NAME"
../merger/createbranch.sh $BRANCH_NAME
read -rep $'Review Results (10 secs to continue)\n' -t 10
echo

echo -e "${YELLOW}[INFO]${NC} Updating from $CURRENT_VERSION to $NEXT_VERSION"
if [ $REPO_NAME == 'aam-jbpm.git' ]; then
   echo aam-jbpm!
  ../merger/update_version.sh ./pom.xml $CURRENT_VERSION $NEXT_VERSION
  ../merger/update_version.sh ./AAM/AAM/pom.xml $CURRENT_VERSION $NEXT_VERSION
  ../merger/update_version.sh ./BBC/BBC/pom.xml $CURRENT_VERSION $NEXT_VERSION
else
   find . -name "pom*.xml" -exec ../merger/update_version.sh {} $CURRENT_VERSION $NEXT_VERSION \;
fi
read -rep $'Review Results (10 secs to continue)\n' -t 10
echo

echo -e "${YELLOW}[INFO]${NC} Committing changes"
../merger/commitandpush.sh $NEXT_VERSION $JIRA
