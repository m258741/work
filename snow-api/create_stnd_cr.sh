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
PAYLOAD="{
  'type': 'standard',
  'chg_model': 'e55d0bfec343101035ae3f52c1d3ae49',
  'category': 'b0fdfb01932002009ca87a75e57ffbe9',
  'template_id': 'c136b71a974902104546f027f053af35',
  'priority': '1 - Critical',
  'risk': 'Critical',
  'impact': 'High (1000+ Users)',
  'assignment_group': 'SG-SN Application Admin',
  'justification': 'this is the justification',
  'start_date': '04/10/2024 05:45:19 PM',
  'end_date': '04/10/2024 05:55:19 PM',
  'u_environment': 'Development',
  'short_description': 'This is the short description',
  'description': 'This is the description'
}"
# addl fields for transition to "scheduled":
# these cannot be set in the initial create
#  'u_business_approver': 'Amy Smith',
#  'u_technical_approver': 'Jisu Dasgupta'

# Working 4/10
#PAYLOAD='{
#  "type": "standard",
#  "chg_model": "e55d0bfec343101035ae3f52c1d3ae49",
#  "priority": "1 - Critical",
#  "assignment_group": "SG-SN Automated Process",
#  "justification": "this is the justification",
#  "start_date": "04/10/2024 05:45:19 PM",
#  "end_date": "04/10/2024 05:55:19 PM",
#  "u_environment": "Production",
#  "short_description": "This is the short description",
#  "description": "This is the description"
#}'
# This works: 'e55d0bfec343101035ae3f52c1d3ae49' is found in get_model_records.py(): 'description': 'ITIL Mode 1 Standard Change'
#PAYLOAD='{
#  "type": "standard",
#  "chg_model": "e55d0bfec343101035ae3f52c1d3ae49"
#}'
# WIP - not working
#PAYLOAD='{
#  "type": "standard",
#  "category": "standard",
#  "chg_model": "c136b71a974902104546f027f053af31",
#  "priority": "1 - Critical",
#  "assignment_group": "SG-SN Automated Process",
#  "justification": "this is the justification",
#  "start_date": "04/09/2024 05:45:19 PM",
#  "end_date": "04/09/2024 05:55:19 PM"
#}'

# DOES NOT WORK: CAHCO model: "chg_model": "c136b71a974902104546f027f053af35",
# WORKS: Invfrastructure Changes - found in chg_model table: "chg_model": "88b7fa2a5323101034d1ddeeff7b12a5",

#PAYLOAD='{
  #"chg_model": "c136b71a974902104546f027f053af31",
  #"priority": "1 - Critical",
  #"assignment_group": "SG-SN Automated Process",
  #"justification": "this is the justification",
  #"start_date": "04/09/2024 05:45:19 PM",
  #"end_date": "04/09/2024 05:55:19 PM"
#}'
# * Priority:
# * Risk: 
# * Short Desc
# * Assignment Group (Sample: "SG-SN Automated Process")
# !Note: Business Approver and Technical Approver are assigned automatically based on the Assignment Group.
# * Justification
# * Planned start date and time (Sample: "04/09/2024 03:35:46 PM")
# * Planned end date and time

# NOT working:
# "chg_model":{"link":"https://maximusdev.service-now.com/api/now/v2/table/chg_model/e55d0bfec343101035ae3f52c1d3ae49","value":"e55d0bfec343101035ae3f52c1d3ae49"}

  # Saved WORKING payload values:
  # "chg_model": "standard", OR: "chg_model": "e55d0bfec343101035ae3f52c1d3ae49",
  # "priority": "1 - Critical",
  # "risk": "Critical",
  # "impact": "High (1000+ Users)",
  # "u_environment": "Production"

# Sample field values:
  #"priority": "1 - Critical", "2 - High", "3 - Moderate", "4 - Low"
  #"risk": "Critical", "High", "Medium", "Low"
  #"impact": "High (1000+ Users)", "Medium (100-999 Users)", "Low (0-99 Users)"
  #"u_environment": "Production"
# 
#"priority": "3",
#"risk": "3",
#"impact": "2"

# * - Required fields per state change:
### State: New
# * Priority:
# * Risk: 
# * Short Desc
# * Assignment Group (Sample: "SG-SN Automated Process")
# !Note: Business Approver and Technical Approver are assigned automatically based on the Assignment Group.
# * Justification
# * Planned start date and time (Sample: "04/09/2024 03:35:46 PM")
# * Planned end date and time
## Optional fields (we should probably fill these in):
# Impact
# Description
#### State: Scheduled


set -x
# change request:
# THIS IS WORKING 4/9:
RESPONSE=$(curl -u "$USERNAME:$PASSWORD" -X POST -H "Content-Type: application/json" -d "$PAYLOAD" "$SNOW_URL/api/now/v2/table/change_request")
#RESPONSE=$(curl -u "$USERNAME:$PASSWORD" -X POST -H "Content-Type: application/json" -d "$PAYLOAD" "$SNOW_URL/sn_chg_rest/change/standard/6d07efd897d146104546f027f053af1f")
#RESPONSE=$(curl -u "$USERNAME:$PASSWORD" -X POST -H "Content-Type: application/json" -d "$PAYLOAD" "$SNOW_URL/api/now/v2/table/change_request/6d07efd897d146104546f027f053af1f")
set +x

#INCIDENT_RESPONSE=$(curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $SESSION_TOKEN" -d "$INCIDENT_DATA" "$SNOW_URL/api/now/v2/table/incident")

# Check the response and handle accordingly
CR_NUMBER=$(echo "$RESPONSE" | jq -r '.result.number')
echo "RESPONSE: $RESPONSE"

if [ -n "$CR_NUMBER" ]; then
  OUTFILE=./output/$CR_NUMBER.json
  echo "CR created successfully: $CR_NUMBER"
  echo "writing json to: $OUTFILE"
  echo "$RESPONSE" | jq . > $OUTFILE
else
  ERROR_MESSAGE=$(echo "$CR_NUMBER" | jq -r '.error.message')
  echo "Failed to create incident: $ERROR_MESSAGE"
fi
