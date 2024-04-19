# Set your ServiceNow instance URL and credentials
#INSTANCE_URL='https://maximusincnonprod23.service-now.com'
INSTANCE_URL='https://maximusdev.service-now.com'
#USERNAME="snow_api"
USERNAME="codeshuttle.user"
PASSWORD='kdndenU212!!8ebhehndeF'

set -x

# Works: curl "${INSTANCE_URL}/api/sn_chg_rest/v1/change/model" \
# c136b71a974902104546f027f053af31 pulled from open query on standard/template, pulling sys_value of template field:
# DOES NOT WORK: curl "${INSTANCE_URL}/api/sn_chg_rest/v1/change/standard/template/c136b71a974902104546f027f053af31" \
# sys_id did NOT work either.
# This is NOT working - is retrieving CRs vs. the template

#curl "${INSTANCE_URL}/api/sn_chg_rest/v1/change/standard/template" \
#curl "${INSTANCE_URL}/api/sn_chg_rest/v1/change/standard/template?sysparm_query=active=false" \
#curl "${INSTANCE_URL}/api/sn_chg_rest/v1/change/standard/template?sysparm_query=sys_id=fb4ebea3473806108895198c326d4321" \
#curl "${INSTANCE_URL}/api/sn_chg_rest/v1/change/standard/template" \

# Codeshuttle template sys_id: 0e33716e97658a104546f027f053af94
curl "${INSTANCE_URL}/api/sn_chg_rest/v1/change/standard/template?sysparm_query=sys_id=0e33716e97658a104546f027f053af94" \
--request GET \
--header "Accept:application/json" \
--user "${USERNAME}":"${PASSWORD}"

exit 0

#INCIDENT_DATA=""
#OBJ_URL='api/now/v2/table/incident'
set -x
#curl -u 'codeshuttle.user:kdndenU212!!8ebhehndeF' -X POST -H "Content-Type: application/json" -d "$INCIDENT_DATA" "$INSTANCE_URL/api/now/v2/table/incident"
# incident:
#curl -u "$USERNAME:$PASSWORD" -X POST -H "Content-Type: application/json" -d "$INCIDENT_DATA" "$INSTANCE_URL/api/now/v2/table/incident"
# change request:
RESPONSE=$(curl -u "$USERNAME:$PASSWORD" -X POST -H "Content-Type: application/json" -d "$INCIDENT_DATA" "$INSTANCE_URL/api/now/v2/table/change_request")
#curl -X POST -H "Content-Type: application/json" -H "Authorization: Basic" -u 'codeshuttle.user:kdndenU212!!8ebhehndeF' -d "$INCIDENT_DATA" "$INSTANCE_URL/api/now/v2/table/incident"
#curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $SESSION_TOKEN" -d "{\"user_name\":\"$USERNAME\",\"user_password\":\"$PASSWORD\"} $INCIDENT_DATA" "$INSTANCE_URL/api/now/v2/table/incident"
set +x

#INCIDENT_RESPONSE=$(curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $SESSION_TOKEN" -d "$INCIDENT_DATA" "$INSTANCE_URL/api/now/v2/table/incident")

# Check the response and handle accordingly
INCIDENT_NUMBER=$(echo "$RESPONSE" | jq -r '.result.number')

if [ -n "$INCIDENT_NUMBER" ]; then
  echo "Incident created successfully. Incident Number: $INCIDENT_NUMBER"
else
  ERROR_MESSAGE=$(echo "$INCIDENT_RESPONSE" | jq -r '.error.message')
  echo "Failed to create incident: $ERROR_MESSAGE"
fi

