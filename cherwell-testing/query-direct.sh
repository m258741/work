#!/bin/bash

testing=1

BEGIN_DATE="02/16/2022 01:00:00 AM"
END_DATE="02/16/2022 12:00:00 PM"

if [[ "$testing" == 1 ]] ; then
endPoint="https://maximustest.cherwellondemand.com/CherwellAPI"
apiKey=3fa93948-f5b7-4d70-b364-f6dabab0564d
userName=Cherwell%5Csvc_TestAPIUser02
clientID=$apiKey
password="DuckWBDSDonald123!"
else
endPoint="https://itservicedesk.maximus.com/CherwellAPI"
apiKey=6c23a176-34d3-41cc-b9e7-0aded677db80
userName=Cherwell%5CSVC_CherAssetDecom
clientID=$apiKey
password="CrimsonHare569^"
fi

# Get auth token
authRet=$(curl -X POST --silent --header "Content-Type: application/x-www-form-urlencoded" --header "Accept: application/json" -d "grant_type=password&client_id=$clientID&username=$userName&password=$password" "$endPoint/token?api_key=$apiKey")

export token=$(echo $authRet | jq .access_token | sed 's/"//g')


# run query:
curl -X POST --header "Content-Type: application/json" --header "Accept: application/json" --header "Authorization: Bearer ${token}" -d "{  \"association\": \"\",  \"associationName\": \"\",  \"busObId\": \"934ec7a1701c451ce57f2c43bfbbe2e46fe4843f81\",  \"customGridDefId\": \"\",  \"dateTimeFormatting\": \"\",  \"fieldId\": \"BO:934ec7a1701c451ce57f2c43bfbbe2e46fe4843f81,FI:934ec7a538b8dc067b5ad944d5bbf774e57d9c0321\",  \"fields\": [    \"BO:934ec7a1701c451ce57f2c43bfbbe2e46fe4843f81,FI:934ec7a538b8dc067b5ad944d5bbf774e57d9c0321\"  ],  \"filters\": [    {      \"fieldId\": \"FI:93e3824368f580ea220edd4c4cb29e44e58a4b2d3b\",      \"operator\": \"gt\",      \"value\": \"${BEGIN_DATE}\"    },    {      \"fieldId\": \"FI:93e3824368f580ea220edd4c4cb29e44e58a4b2d3b\",      \"operator\": \"lt\",      \"value\": \"${END_DATE}\"    }    ],  \"includeAllFields\": true,  \"includeSchema\": true,  \"pageNumber\": 0,  \"pageSize\": 0,  \"scope\": \"Global\",  \"scopeOwner\": \"(None)\", }" "https://maximustest.cherwellondemand.com/CherwellAPI/api/V1/getsearchresults"


