# Set your ServiceNow instance URL and credentials
#INSTANCE_URL='https://maximusincnonprod23.service-now.com'
INSTANCE_URL='https://maximusdev.service-now.com'
#USERNAME="snow_api"
USERNAME="codeshuttle.user"
PASSWORD='kdndenU212!!8ebhehndeF'

set -x

# Authenticate and obtain the session token
#TOKEN_RESPONSE=$(curl -X POST -H "Content-Type: application/json" -d "{\"user_name\":\"$USERNAME\",\"user_password\":\"$PASSWORD\"}" "$INSTANCE_URL/api/now/v2/table/sys_user_session")
#SESSION_TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.result.session_id')

# Create an incident
INCIDENT_DATA='{
  "short_description": "API Test Incident",
  "description": "This is a test incident created via API."
}'

CR_NUMBER='CHG0030373'

# if $1 is set, override CR number
if [ -n "$1" ]; then
  CR_NUMBER="$1"
fi

#INCIDENT_DATA=""
#OBJ_URL='api/now/v2/table/incident'
set -x
# Retrieve the CR, and parse the sys_id (below)
RESPONSE=$(curl -u "$USERNAME:$PASSWORD" -X GET -H "Content-Type: application/json" "$INSTANCE_URL/api/sn_chg_rest/v1/change?number=${CR_NUMBER}")
set +x

echo "$RESPONSE" > /tmp/fetch.json

# Check the response and handle accordingly
echo $RESPONSE | jq . > /tmp/cr.json
CR_NUMBER=$(echo "$RESPONSE" | jq -r '.result[0].number.value')
SYS_ID=$(echo "$RESPONSE" | jq -r '.result[0].sys_id.value')
echo "SYS_ID: $SYS_ID"

UPDATE_PAYLOAD="{
  'state': 'Scheduled',
  'short_description': 'UPDATED 2: moved state to scheduled',
}"
# move to 'implement' (Q: do we need to set the business and technical approvers??)
#UPDATE_PAYLOAD="{
#  'state': 'Scheduled',
#  'short_description': 'UPDATED 2: moved state to scheduled',
#  'u_business': '1f19b06197c902104546f027f053afec',
#  'u_technical': '735ac2ca47936510a71c1347e26d43d5'
#}"
# works:
echo sleeping before update...
sleep 5
# Update the CR:
#RESPONSE=$(curl -u "$USERNAME:$PASSWORD" -X PATCH -H "Content-Type: application/json" "$INSTANCE_URL/api/sn_chg_rest/v1/change/${SYS_ID}" -d "{'state': 'scheduled'}")
# this worked:
#RESPONSE=$(curl -u "$USERNAME:$PASSWORD" -X PATCH -H "Content-Type: application/json" "$INSTANCE_URL/api/sn_chg_rest/v1/change/${SYS_ID}" -d "{'short_description': 'SHORT DESC UPDATED'}")
RESPONSE=$(curl -u "$USERNAME:$PASSWORD" -X PATCH -H "Content-Type: application/json" "$INSTANCE_URL/api/sn_chg_rest/v1/change/${SYS_ID}" -d "${UPDATE_PAYLOAD}")

echo "PATCH RESPONSE: $RESPONSE"
echo "PATCH RESPONSE: $RESPONSE" > /tmp/patched.json

if [ -n "$CR_NUMBER" ]; then
  echo "CR fetched successfully: $CR_NUMBER"
else
  ERROR_MESSAGE=$(echo "$CR_NUMBER" | jq -r '.error.message')
  echo "Failed to fetch CR: $ERROR_MESSAGE"
fi

