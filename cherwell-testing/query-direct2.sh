#!/bin/bash

#fieldId_actualEndDate='FI:9366b32ec2ffd04910c99e45848a9dd407e43e6c61'
#fieldId_status='FI:93543f5c71a782465c27994bba9bd8f1dece6dded8'
fieldId_type='FI:93e087d5c4133875726485473a8bd4c2a14fa954da'
fieldId_title='FI:9386ce5880c4ea6f41d4c14e1ca01237170049b3e7'
#status1='Implementation in Progress'
#status2='Waiting for Implementation'
typeValue="Standard"
#statusValue="Final Change Review"
pageSize="10000"
titleValue="test CR created by tlowe in test"

#beginDate="$1"
#endDate="$2"
jsonOutFile="json.out"
env="dev"

if [[ "$env" == "dev" ]] ; then
    endPoint="https://maximustest.cherwellondemand.com/CherwellAPI"
    userName=Cherwell%5Csvc_TestAPIUser02
    # Load secure strings from .secrets
    API_KEY="3fa93948-f5b7-4d70-b364-f6dabab0564d"
    API_PW="DuckWBDSDonald123!"
    #userName='Cherwell\svc_TestAPIUser02'
elif [[ "$env" == "prod" ]] ; then
    endPoint="https://itservicedesk.maximus.com/CherwellAPI"
    userName=Cherwell%5CSVC_CherAssetDecom
    # Load secure strings from .secrets
    API_KEY="$(grep API_KEY_PROD .secrets | cut -f2 -d':' | base64 -d)"
    API_PW="$(grep API_PW_PROD .secrets | cut -f2 -d':' | base64 -d)"
else
	echo "Error: invalid env specified."
	exit 1
fi

# Get auth token
#echo "API_PW: $API_PW"
#echo "API_KEY: $API_KEY"
#echo "USERNAME: $userName"
set -x
authResponse=$(curl -X POST --silent --header "Content-Type: application/x-www-form-urlencoded" --header "Accept: application/json" -d "grant_type=password&client_id=${API_KEY}&username=$userName&password=${API_PW}" "${endPoint}/token?api_key=${API_KEY}")

export TOKEN=$(echo $authResponse | jq .access_token | sed 's/"//g')
set +x

# Do query
set -x
curl -X POST --header "Content-Type: application/json" --header "Accept: application/json" --header "Authorization: Bearer ${TOKEN}" -d "{  \"association\": \"\",  \"associationName\": \"\",  \"busObId\": \"934ec7a1701c451ce57f2c43bfbbe2e46fe4843f81\",  \"customGridDefId\": \"\",  \"dateTimeFormatting\": \"\",   \
 \"filters\": [    \
{      \"fieldId\": \"${fieldId_type}\",      \"operator\": \"eq\",      \"value\": \"${typeValue}\"    }, \
{      \"fieldId\": \"${fieldId_title}\",      \"operator\": \"eq\",      \"value\": \"${titleValue}\"    }, \
  ],  \"includeAllFields\": true,  \"includeSchema\": true,  \"pageNumber\": 0,  \"pageSize\": ${pageSize},  \"scope\": \"Global\",  \"scopeOwner\": \"(None)\", }" "${endPoint}/api/V1/getsearchresults" > $jsonOutFile
curlStatus=$?
set +x

echo "Wrote output file: $jsonOutFile"

# Exit w/ success or fail exit code
if [ $curlStatus -ne 0 ]; then
	exit 1
else
	exit 0
fi
