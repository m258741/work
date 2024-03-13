#!/bin/bash
# Replace <YOUR_ARTIFACTORY_URL> and <YOUR_API_KEY> with your actual Artifactory URL and API key
ARTIFACTORY_URL="https://artifactory.mars.pcf-maximus.com"
API_KEY="YOUR_API_KEY"

# Set the repository name
REPO_NAME=tlowe-repo

# API endpoint for creating a new repository
CREATE_REPO_ENDPOINT="${ARTIFACTORY_URL}/artifactory/api/repositories/${REPO_NAME}"
FETCH_REPO_ENDPOINT="${ARTIFACTORY_URL}/artifactory/${REPO_NAME}"

# JSON data for the repository configuration
REPO_CONFIG='{
  "key": "'${REPO_NAME}'",
  "rclass": "local",
  "packageType": "generic",
  "description": "My new repository",
  "notes": "Created via Artifactory REST API"
}'

# Use cURL to create the repository
#curl -X PUT -H "Authorization: Bearer ${API_KEY}" -H "Content-Type: application/json" -d "${REPO_CONFIG}" "${CREATE_REPO_ENDPOINT}"

USER='scm-pipeline-artifactory'
PW='J3nkinsF00B@r'
set -x
#curl -u $USER:$PW -X PUT "${ARTIFACTORY_URL}/tlowe-repository/my/new/artifact/directory/file.txt" -T ./testfile.txt

# WORKS:
#curl -u ${USER}:${PW} -X PUT -H "Content-Type: application/json" -d "${REPO_CONFIG}" "${CREATE_REPO_ENDPOINT}"

#curl -s -o /dev/null -w "%{http_code}" ${FETCH_REPO_ENDPOINT}
BREAK_IT=""
#HTTP_STATUS=$(curl -s -w "%{http_code}" ${FETCH_REPO_ENDPOINT}${BREAK_IT} | jq -r errors[0].status)
#HTTP_STATUS=$(curl -s -w "%{http_code}" ${FETCH_REPO_ENDPOINT}${BREAK_IT} | jq -r .errors[].status)

#ACCEPT_TYPE="application/json"
#ACCEPT_TYPE='application/x-tar'
ACCEPT_TYPE='*/*'
curl -s -w "%{http_code}" -H "Accept: ${ACCEPT_TYPE}" ${FETCH_REPO_ENDPOINT}/
echo "===="
# with trailing slash:
#curl -s -w "%{http_code}" ${FETCH_REPO_ENDPOINT}
echo "Return code: $?"
echo "Status: $HTTP_STATUS"
