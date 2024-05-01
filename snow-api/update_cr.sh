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

# NOTE!: short_description field update was blocked, during transition to "Closed"
UPDATE_PAYLOAD4="{
  'state': 'Closed',
  'close_code': 'Successful',
  'close_notes': 'Codeshuttle deployment successful',
  'short_description': 'UPDATE 4: moved state to scheduled',
  'description': 'UPDATE 4: moved state to scheduled'
}"
UPDATE_PAYLOAD3="{
  'state': 'Final Review',
  'short_description': 'UPDATE 3: moved state to scheduled',
  'description': 'UPDATE 3: moved state to scheduled'
}"
#move to 'Implement' (Q: do we need to set the business and technical approvers??)
UPDATE_PAYLOAD2="{
  'state': 'Implement',
  'short_description': 'UPDATE 2: moved state to scheduled',
  'description': 'UPDATE 2: moved state to scheduled'
}"
#move to 'Scheduled' (Q: do we need to set the business and technical approvers??)
# NOTE: cannot update Description field - blocked by ServiceNow
# NOTE: short_description can ONLY be updated in this 'Scheduled' transition update - later updates blocked by ServiceNow
UPDATE_PAYLOAD1="{
  'state': 'Scheduled',
  'short_description': 'UPDATED 1: moved state to scheduled',
  'u_business': '1f19b06197c902104546f027f053afec',
  'u_technical': '735ac2ca47936510a71c1347e26d43d5'
}"
# works:
echo pausing before update...
sleep 2
# START HERE:
echo "hit ret to do 1(Scheduled)..."
read yn
RESPONSE=$(curl -u "$USERNAME:$PASSWORD" -X PATCH -H "Content-Type: application/json" "$INSTANCE_URL/api/sn_chg_rest/v1/change/${SYS_ID}" -d "${UPDATE_PAYLOAD1}")
echo "RESPONSE: $RESPONSE"
# RESPONSE with 'description' in payload: 
# {"error":{"message":"Change Request record could not be updated. Operation against file 'change_request' was aborted by Business Rule 'Restrict fields from Standard Change^5230b9179735ca504546f027f053af79'. Business Rule Stack:Restrict fields from Standard Change","detail":""},"status":"failure"}
echo "hit ret to do 2...(Implement)"
read yn
RESPONSE=$(curl -u "$USERNAME:$PASSWORD" -X PATCH -H "Content-Type: application/json" "$INSTANCE_URL/api/sn_chg_rest/v1/change/${SYS_ID}" -d "${UPDATE_PAYLOAD2}")
echo "RESPONSE: $RESPONSE"
# RESPONSE: "__meta":{"ignoredFields":["short_description","description"]}}}
# note: despite short_description field seeming to be ignored, in the response above, the value actually DID change, in the UI.
echo "hit ret to do 3...(Final Review)"
read yn
RESPONSE=$(curl -u "$USERNAME:$PASSWORD" -X PATCH -H "Content-Type: application/json" "$INSTANCE_URL/api/sn_chg_rest/v1/change/${SYS_ID}" -d "${UPDATE_PAYLOAD3}")
echo "RESPONSE: $RESPONSE"
echo "hit ret to do 4...(Closed)"
read yn
RESPONSE=$(curl -u "$USERNAME:$PASSWORD" -X PATCH -H "Content-Type: application/json" "$INSTANCE_URL/api/sn_chg_rest/v1/change/${SYS_ID}" -d "${UPDATE_PAYLOAD4}")
echo "RESPONSE: $RESPONSE"

if [ -n "$CR_NUMBER" ]; then
  echo "CR fetched successfully: $CR_NUMBER"
else
  ERROR_MESSAGE=$(echo "$CR_NUMBER" | jq -r '.error.message')
  echo "Failed to fetch CR: $ERROR_MESSAGE"
fi

