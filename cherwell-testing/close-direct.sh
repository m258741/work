#!/bin/bash

testing=1
TMPFILE=/tmp/tmp.$$

CR="$1"

if [[ "$testing" == 1 ]] ; then
endPoint="https://maximustest.cherwellondemand.com/CherwellAPI"
apiKey=3fa93948-f5b7-4d70-b364-f6dabab0564d
userName=Cherwell%5Csvc_TestAPIUser02
clientID=$apiKey
password="DuckWBDSDonald123!"
else
endPoint="https://itservicedesk.maximus.com/CherwellAPI"
apiKey=CHANGME
userName=Cherwell%5CSVC_CherAssetDecom
clientID=$apiKey
password="CHANGEME"
fi

# Get auth token
authRet=$(curl -X POST --silent --header "Content-Type: application/x-www-form-urlencoded" --header "Accept: application/json" -d "grant_type=password&client_id=$clientID&username=$userName&password=$password" "$endPoint/token?api_key=$apiKey")

export TOKEN=$(echo $authRet | jq .access_token | sed 's/"//g')


# update BO:
curl -i -X POST --header "Content-Type: application/json" --header "Accept: application/json" --header "Authorization: Bearer ${TOKEN}" -d "{  \"busObId\": \"934ec7a1701c451ce57f2c43bfbbe2e46fe4843f81\",  \"busObPublicId\": \"${CR}\",  \"busObRecId\": \"\",  \"cacheKey\": \"\",  \"cacheScope\": \"Tenant\",  \"fields\": [    {      \"dirty\": true,      \"displayName\": \"Change Area\",      \"fieldId\": \"BO:934ec7a1701c451ce57f2c43bfbbe2e46fe4843f81,FI:9414139beb76e2308c41324465825062d2538f56f7\",      \"fullFieldId\": \"\",      \"html\": \"\",      \"name\": \"ChangeArea\",      \"value\": \"Database\"    },    \
{      \"dirty\": true,      \"displayName\": \"Final Disposition\",      \"fieldId\": \"BO:934ec7a1701c451ce57f2c43bfbbe2e46fe4843f81,FI:93e029113427c0108137d7447aad216f824eee8b3b\",      \"fullFieldId\": \"\",      \"html\": \"\",      \"name\": \"FinalDisposition\",      \"value\": \"Successfully Completed\"    }, \
{      \"dirty\": true,      \"displayName\": \"Current Step\",      \"fieldId\": \"BO:934ec7a1701c451ce57f2c43bfbbe2e46fe4843f81,FI:93e2129388a371f185ec31465cbb0d601441618b2e\",      \"fullFieldId\": \"\",      \"html\": \"\",      \"name\": \"CurrentStep\",      \"value\": \"99\"    }, \
{      \"dirty\": true,      \"displayName\": \"Highest Step\",      \"fieldId\": \"BO:934ec7a1701c451ce57f2c43bfbbe2e46fe4843f81,FI:93e373d74d2935da54d54f4106a26e332eff056584\",      \"fullFieldId\": \"\",      \"html\": \"\",      \"name\": \"HighestStep\",      \"value\": \"99\"    }, \
{      \"dirty\": true,      \"displayName\": \"Embedded Form Display\",      \"fieldId\": \"BO:934ec7a1701c451ce57f2c43bfbbe2e46fe4843f81,FI:93e1f51bbac30fbd7690c24184baa403dd3fdf3179\", \"fullFieldId\": \"\",      \"html\": \"\",      \"name\": \"EmbeddedFormDisplay\",      \"value\": \"MaximusExpandedPreauthorized\"    }, \
{      \"dirty\": true,      \"displayName\": \"Expanded Form\",      \"fieldId\": \"BO:934ec7a1701c451ce57f2c43bfbbe2e46fe4843f81,FI:93e245015e6fdfee196c684d73b931cb28b4813299\", \"fullFieldId\": \"\",      \"html\": \"\",      \"name\": \"ExpandedForm\",      \"value\": \"MaximusExpandedPreauthorized\" }, \
{      \"dirty\": true,      \"displayName\": \"Status ID\",      \"fieldId\": \"BO:934ec7a1701c451ce57f2c43bfbbe2e46fe4843f81,FI:93c73bf250a4ec0d433fd84a3883d93f65ea7d9e57\",      \"fullFieldId\": \"\",      \"html\": \"\",      \"name\": \"StatusID\",      \"value\": \"9414565b2e174d89d2eb4947d6a5543d2e4e372172\"    },  \
{      \"dirty\": true,      \"displayName\": \"Embedded Form Toggle\",      \"fieldId\": \"BO:934ec7a1701c451ce57f2c43bfbbe2e46fe4843f81,FI:93e2c8014ca803645406e44e40b9295f88e73fea33\",      \"fullFieldId\": \"\",      \"html\": \"\",      \"name\": \"EmbeddedFormToggle\",      \"value\": \"MaximusExpandedPreauthorized\"    }, \
{      \"dirty\": true,      \"displayName\": \"Status\",      \"fieldId\": \"BO:934ec7a1701c451ce57f2c43bfbbe2e46fe4843f81,FI:93543f5c71a782465c27994bba9bd8f1dece6dded8\",      \"fullFieldId\": \"\",      \"html\": \"\",      \"name\": \"Status\",      \"value\": \"Closed\"    } \
],  \"persist\": true}" \
"https://maximustest.cherwellondemand.com/CherwellAPI/api/V1/savebusinessobject" 


# 400 status:
# {      \"dirty\": true,      \"displayName\": \"Status\",      \"fieldId\": \"BO:934ec7a1701c451ce57f2c43bfbbe2e46fe4843f81,FI:93543f5c71a782465c27994bba9bd8f1dece6dded8\",      \"fullFieldId\": \"\",      \"html\": \"\",      \"name\": \"Status\",      \"value\": \"Closed\"    }, \ 

# 400 status:
#{      \"dirty\": true,      \"displayName\": \"\Embedded Form Toggle\",      \"fieldId\": \"BO:934ec7a1701c451ce57f2c43bfbbe2e46fe4843f81,FI:93e2c8014ca803645406e44e40b9295f88e73fea33\", \"fullFieldId\": \"\",      \"html\": \"\",      \"name\": \"EmbeddedFormToggle\",      \"value\": \"MaximusExpandedPreauthorized\"    }, \


#  ],  \"persist\": true}" \
#"https://maximustest.cherwellondemand.com/CherwellAPI/api/V1/savebusinessobject" 

exit 0

# get HTTP status
HTTP_STATUS="`grep 'HTTP' $TMPFILE | cut -f2 -d' '`"

# get response hasError field
HAS_ERROR="`grep busObPublicId $TMPFILE | jq .hasError`"

# output values parsed
echo "HTTP RESPONSE CODE: $HTTP_STATUS"
echo "hasError: $HAS_ERROR"

exit 0


