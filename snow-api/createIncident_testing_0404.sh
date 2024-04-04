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

#INCIDENT_DATA=""
OBJ_URL='api/now/v2/table/incident'
curl -X POST -H "Content-Type: application/json" -H "Authorization: Basic" -u 'codeshuttle.user:kdndenU212!!8ebhehndeF' -d "$INCIDENT_DATA" "$INSTANCE_URL/api/now/v2/table/incident"
#curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $SESSION_TOKEN" -d "{\"user_name\":\"$USERNAME\",\"user_password\":\"$PASSWORD\"} $INCIDENT_DATA" "$INSTANCE_URL/api/now/v2/table/incident"

#INCIDENT_RESPONSE=$(curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $SESSION_TOKEN" -d "$INCIDENT_DATA" "$INSTANCE_URL/api/now/v2/table/incident")

# Check the response and handle accordingly
INCIDENT_NUMBER=$(echo "$INCIDENT_RESPONSE" | jq -r '.result.number')

if [ -n "$INCIDENT_NUMBER" ]; then
  echo "Incident created successfully. Incident Number: $INCIDENT_NUMBER"
else
  ERROR_MESSAGE=$(echo "$INCIDENT_RESPONSE" | jq -r '.error.message')
  echo "Failed to create incident: $ERROR_MESSAGE"
fi

