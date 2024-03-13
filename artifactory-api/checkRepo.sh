#!/bin/bash
# Replace <YOUR_ARTIFACTORY_URL> and <YOUR_API_KEY> with your actual Artifactory URL and API key
ARTIFACTORY_URL="https://artifactory.mars.pcf-maximus.com"
#API_KEY="YOUR_API_KEY"

# Set the repository name
REPO_NAME=tlowe-repo

# API endpoint for creating a new repository
FETCH_REPO_ENDPOINT="${ARTIFACTORY_URL}/artifactory/${REPO_NAME}"

# Use cURL to create the repository
#curl -X PUT -H "Authorization: Bearer ${API_KEY}" -H "Content-Type: application/json" -d "${REPO_CONFIG}" "${CREATE_REPO_ENDPOINT}"

#set -x

ACCEPT_TYPE='*/*'
HTTP_STATUS=$(curl -s -w "%{http_code}" -H "Accept: ${ACCEPT_TYPE}" ${FETCH_REPO_ENDPOINT}/)
echo "===="
# without trailing slash:
#curl -s -w "%{http_code}" ${FETCH_REPO_ENDPOINT}
echo "Return code: $?"
echo "Status: $HTTP_STATUS"
