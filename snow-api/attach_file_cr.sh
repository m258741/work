SNOW_URL='https://maximusdev.service-now.com'
#USERNAME="snow_api"
USERNAME="codeshuttle.user"
PASSWORD='kdndenU212!!8ebhehndeF'

# Set variables
CR_NUMBER="CHG0030520"
FILE_PATH="./input.txt"
FILE_NAME="input.txt"
 
# Get sys_id of an existing change request
RESPONSE=$(curl -u "$USERNAME:$PASSWORD" -X GET -H "Content-Type: application/json" "$SNOW_URL/api/sn_chg_rest/v1/change?number=${CR_NUMBER}")
set +x

echo "$RESPONSE" > /tmp/fetch.json

# Check the response and handle accordingly
echo $RESPONSE | jq . > /tmp/cr.json
CR_NUMBER=$(echo "$RESPONSE" | jq -r '.result[0].number.value')
SYS_ID=$(echo "$RESPONSE" | jq -r '.result[0].sys_id.value')
echo "SYS_ID: $SYS_ID"

# Attach the file to CR:
# ServiceNow API endpoint for attaching a file
URL="${SNOW_URL}/api/now/attachment/file?table_name=change_request&table_sys_id=${SYS_ID}&file_name=${FILE_NAME}"
 
# Make the API call to attach the file
curl -u "${USERNAME}:${PASSWORD}" \
     -X POST \
     -H "Accept:application/json" \
     -H "Content-Type:application/octet-stream" \
     --data-binary "@${FILE_PATH}" \
     "${URL}" \
     -o response.json
 
# Check and display the response
echo "Response saved to response.json"
# append a newline to the response.json file, so we can see it when cat it
echo "" >> response.json
cat response.json