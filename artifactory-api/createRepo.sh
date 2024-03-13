#!/bin/bash
# Replace <YOUR_ARTIFACTORY_URL> and <YOUR_API_KEY> with your actual Artifactory URL and API key
ARTIFACTORY_URL="https://artifactory.mars.pcf-maximus.com"
#API_KEY="YOUR_API_KEY"

#REPO_TYPE="generic"
#REPO_LAYOUT="simple-default"
REPO_TYPE="npm"
REPO_LAYOUT="npm-default"

# Set the repository name
REPO_NAME=tlowe-repo-test-${REPO_TYPE}

if [ "$1" != "" ]; then
  REPO_NAME="$1"
fi

# API endpoint for creating a new repository
CREATE_REPO_ENDPOINT="${ARTIFACTORY_URL}/artifactory/api/repositories/${REPO_NAME}"

# JSON data for the repository configuration
REPO_CONFIG='{
  "key": "'${REPO_NAME}'",
  "suppressPomConsistencyChecks": true,
  "propertySets": [ "artifactory" ],
  "xrayIndex": true,
  "xrayDataTtl": 0,
  "rclass": "local",
  "packageType": "'${REPO_TYPE}'",
  "description": "a test repository",
  "notes": "Created via Artifactory REST API",
  "xrayIndex": true,
  "repoLayoutRef": "'${REPO_LAYOUT}'"
}'

# Use cURL to create the repository
#curl -X PUT -H "Authorization: Bearer ${API_KEY}" -H "Content-Type: application/json" -d "${REPO_CONFIG}" "${CREATE_REPO_ENDPOINT}"

USER='scm-pipeline-artifactory'
PW='J3nkinsF00B@r'

set -x

#curl -u $USER:$PW -X PUT "${ARTIFACTORY_URL}/tlowe-repository/my/new/artifact/directory/file.txt" -T ./testfile.txt

# WORKS:
curl -u ${USER}:${PW} -X PUT -H "Content-Type: application/json" -d "${REPO_CONFIG}" "${CREATE_REPO_ENDPOINT}"

exit $?
