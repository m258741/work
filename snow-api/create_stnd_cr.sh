# Set your ServiceNow instance URL and credentials
#SNOW_URL='https://maximusincnonprod23.service-now.com'
SNOW_URL='https://maximusdev.service-now.com'
#USERNAME="snow_api"
USERNAME="codeshuttle.user"
PASSWORD='kdndenU212!!8ebhehndeF'

set -x

# Authenticate and obtain the session token
#TOKEN_RESPONSE=$(curl -X POST -H "Content-Type: application/json" -d "{\"user_name\":\"$USERNAME\",\"user_password\":\"$PASSWORD\"}" "$SNOW_URL/api/now/v2/table/sys_user_session")
#SESSION_TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.result.session_id')

# Create an incident
PAYLOAD='{
  "short_description": "API Test: create STANDARD CR.",
  "description": "This is a test: STANDARD CR created via SNOW REST API.",
  "chg_model": "standard"
}'

set -x
# change request:
RESPONSE=$(curl -u "$USERNAME:$PASSWORD" -X POST -H "Content-Type: application/json" -d "$PAYLOAD" "$SNOW_URL/api/now/v2/table/change_request")
#RESPONSE=$(curl -u "$USERNAME:$PASSWORD" -X POST -H "Content-Type: application/json" -d "$INCIDENT_DATA" "$SNOW_URL/sn_chg_rest/change/standard/6d07efd897d146104546f027f053af1f")
#RESPONSE=$(curl -u "$USERNAME:$PASSWORD" -X POST -H "Content-Type: application/json" -d "$INCIDENT_DATA" "$SNOW_URL/api/now/v2/table/change/standard_request/standard/6d07efd897d146104546f027f053af1f")
set +x

#INCIDENT_RESPONSE=$(curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $SESSION_TOKEN" -d "$INCIDENT_DATA" "$SNOW_URL/api/now/v2/table/incident")

# Check the response and handle accordingly
#INCIDENT_NUMBER=$(echo "$RESPONSE" | jq -r '.result.number')
echo "RESPONSE: $RESPONSE"
exit 0

if [ -n "$INCIDENT_NUMBER" ]; then
  echo "Incident created successfully. Incident Number: $INCIDENT_NUMBER"
else
  ERROR_MESSAGE=$(echo "$INCIDENT_RESPONSE" | jq -r '.error.message')
  echo "Failed to create incident: $ERROR_MESSAGE"
fi