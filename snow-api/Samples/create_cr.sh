#!/bin/bash

# Set your ServiceNow instance URL and credentials
INSTANCE_URL='https://maximusdev.service-now.com'
USERNAME="codeshuttle.user"
PASSWORD='password-value'

set -x

# Create an incident
PAYLOAD='{
  "short_description": "API Test CR",
  "description": "This is a test CR created via API."
}'

set -x
# create change request:
RESPONSE=$(curl -u "$USERNAME:$PASSWORD" -X POST -H "Content-Type: application/json" -d "$PAYLOAD" "$INSTANCE_URL/api/now/v2/table/change_request")
# Check the response and handle accordingly
CR_NUMBER=$(echo "$RESPONSE" | jq -r '.result.number')
set +x

if [ -n "$CR_NUMBER" ]; then
  echo "Incident created successfully. Incident Number: $CR_NUMBER"
else
  # UNDER CONSTRUCTION: this piece may be legacy cherwell - may not work:
  #ERROR_MESSAGE=$(echo "$RESPONSE" | jq -r '.error.message')
  echo "Error: Failed to create incident"
fi

