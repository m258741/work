#! /bin/bash

#set -x

#base_url='https://omdb.maximus.com/cmdbuild/services/rest/v3'
base_url='https://omdb.maximus.com/cmdbuild'


#curl -s -k -X GET -H "Cmdbuild-authorization:$id" -H "Content-Type:application/json" ${sw_url} | jq --arg quote '"' '.data[] | join("~")' | tr -d '"' >> $outfile
curl -s -k -X GET ${base_url} 


exit 0

