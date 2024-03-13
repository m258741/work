# Set your ServiceNow instance URL and credentials
INSTANCE_URL='https://maximusincnonprod23.service-now.com'
USERNAME="snow_api"
PASSWORD='kDas-@pIobg]N4;j{>BXTB!GF}wuRVl,?w?_i<YUGkDV_UdK&ANNc{#0-9L*Ykky-gZ+zQg5WTpC*P;&4p-n:+eh0w[n0gn%1PY3'

# Authenticate and obtain the session token
TOKEN_RESPONSE=$(curl -X POST -H "Content-Type: application/json" -d "{\"user_name\":\"$USERNAME\",\"user_password\":\"$PASSWORD\"}" "$INSTANCE_URL/api/now/v2/table/sys_user_session")
SESSION_TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.result.session_id')

exit 1

# Create an incident
INCIDENT_DATA='{
  "short_description": "API Test Incident",
  "description": "This is a test incident created via API."
}'

INCIDENT_RESPONSE=$(curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $SESSION_TOKEN" -d "$INCIDENT_DATA" "$INSTANCE_URL/api/now/v2/table/incident")

# Check the response and handle accordingly
INCIDENT_NUMBER=$(echo "$INCIDENT_RESPONSE" | jq -r '.result.number')

if [ -n "$INCIDENT_NUMBER" ]; then
  echo "Incident created successfully. Incident Number: $INCIDENT_NUMBER"
else
  ERROR_MESSAGE=$(echo "$INCIDENT_RESPONSE" | jq -r '.error.message')
  echo "Failed to create incident: $ERROR_MESSAGE"
fi

