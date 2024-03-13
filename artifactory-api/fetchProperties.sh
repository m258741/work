#!/bin/bash
# Replace <YOUR_ARTIFACTORY_URL> and <YOUR_API_KEY> with your actual Artifactory URL and API key
ARTIFACTORY_URL="https://artifactory.mars.pcf-maximus.com"
#API_KEY="YOUR_API_KEY"

USER='scm-pipeline-artifactory'
PW='J3nkinsF00B@r'

# Set the repository name
REPO_NAME=tlowe-repo

# take reponame from command line
if [ "$1" != "" ]; then
  REPO_NAME="$1"
fi

# API endpoint for creating a new repository
FETCH_REPO_ENDPOINT="${ARTIFACTORY_URL}/artifactory/api/repositories/${REPO_NAME}"

# Use cURL to create the repository
#curl -X PUT -H "Authorization: Bearer ${API_KEY}" -H "Content-Type: application/json" -d "${REPO_CONFIG}" "${CREATE_REPO_ENDPOINT}"

set -x

ACCEPT_TYPE='*/*'
#curl -u $USER:$PW -X GET -H "Accept: ${ACCEPT_TYPE}" ${FETCH_REPO_ENDPOINT}/
curl -u $USER:$PW -X GET -H "Accept: ${ACCEPT_TYPE}" ${FETCH_REPO_ENDPOINT}
