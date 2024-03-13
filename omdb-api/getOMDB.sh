#! /bin/bash

#set -x

user="APIReadOnly"
pw=`grep $user .secrets | cut -f2 -d':' | base64 -d`
outfile="/tmp/out.csv"

payload="{
  \"username\": \"APIReadOnly\",
  \"password\": \"${pw}\"
}"

# set "header" row for csv
header='_id~_type~_user~__user_description~_beginDate~known_to_qualys~known_to_lansweeper~Hostname~Version~Product~_Product_code~_Product_description~WarrantyEnd~known_to_bigfix~EOLDate~Building~_Building_code~_Building_description~Description~spkfwdr_app_lastseen~knwn_to_splkfwdr_app~Code~State~known_to_vmware~bigfix_last_seen~qualys_last_seen~lansweeper_last_seen~vmware_last_reported~ssm_last_seen~known_to_ssm~CmJoinTableDummyRef_ServerSW~_CmJoinTableDummyRef_ServerSW_code~_CmJoinTableDummyRef_ServerSW_description~CmJoinTableDummyRef_Hardware~_CmJoinTableDummyRef_Hardware_code~_CmJoinTableDummyRef_Hardware_description~CmJoinTableDummyRef_SWCatalogue~_CmJoinTableDummyRef_SWCatalogue_code~_CmJoinTableDummyRef_SWCatalogue_description~CmJoinTableDummyRef_C_AWSAccounts'

#echo "payload: $payload"

base_url='https://omdb.maximus.com/cmdbuild/services/rest/v3'
#sw_url="${base_url}/classes/ServerSW/cards"
sw_url="${base_url}/views/server_software_full/cards"

results=$(curl -s -k -X POST -d "$payload" -H "Content-Type:application/json"  ${base_url}/sessions?scope=service\&returnId=true)

id=$(echo $results | jq '.data._id' | sed 's/"//g')

# Create 1st line of csv - Excel separator directive
echo "sep=~" > $outfile
# append header to csv
## DISABLE header for testing:
## echo "$header" >> $outfile

#curl -s -k -X GET -H "Cmdbuild-authorization:$id" -H "Content-Type:application/json" ${base_url}/classes/Building/cards | jq --arg quote '"' '.data[] | .Code + $quote + "," + .WorkdayLocIdentifer' | sed -e 's/\\//g' -e 's/\"$//' | grep -v ',$'
#curl -s -k -X GET -H "Cmdbuild-authorization:$id" -H "Content-Type:application/json" ${sw_url} -d output_mode=csv
#curl -s -k -X GET -H "Cmdbuild-authorization:$id" -H "Content-Type:application/json" ${sw_url} 
#curl -s -k -X GET -H "Cmdbuild-authorization:$id" -H "Content-Type:application/json" ${sw_url} | jq --arg quote '"' '.data[]'
curl -s -k -X GET -H "Cmdbuild-authorization:$id" -H "Content-Type:application/json" ${sw_url} | jq --arg quote '"' '.data[] | join("~")' | tr -d '"' >> $outfile

echo "Output to file: $outfile"

exit 0

