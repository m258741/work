#!/bin/bash

spk_server="splunk.maximus.com"
spk_token="eyJraWQiOiJzcGx1bmsuc2VjcmV0IiwiYWxnIjoiSFM1MTIiLCJ2ZXIiOiJ2MiIsInR0eXAiOiJzdGF0aWMifQ.eyJpc3MiOiIyXzg3OTQ0IGZyb20gdXZhYXBtbXNyaDAxc3BrIiwic3ViIjoiYXBpX2NvZGVzaHV0dGxlIiwiYXVkIjoiY29kZXNodXR0bGUiLCJpZHAiOiJTcGx1bmsiLCJqdGkiOiI0NmY4NDVmNDE5MDFhMjQ2ZmVkYjNjZTQ4YmM0NzIyYTFhNTY4MGQwNWQ2ZjBlMTBhMTcwYTRmNWYzYjNlM2Q4IiwiaWF0IjoxNjY0MzEwMjIwLCJleHAiOjE2OTU4NDYyMjAsIm5iciI6MTY2NDMxMDIyMH0.0K26f4Qr5O_6dIz774anM5G7zjNlLZxIfVikLaDtgglNWF_225oDmHXifTjKG6EKReD5BLV6U9ndb4ha1ejIvA"
# default format, override on command line
format=json

# Command line Args:
# Arg 1: Format (values: 'json' or 'csv')
if [ "$1" != "" ]; then
  format=$1
fi

if [ "$format" = "json" ]; then
  extra_args='| jq .results[0]'
else
  extra_args=''
fi

curl -s -H "Authorization: Bearer $spk_token" https://$spk_server:8089/services/search/jobs \
-d search='search index=max_inventory source=aws:organizations sourcetype=account  account=* status=ACTIVE accountid=* organization_account_alias=maximus-masteraccount | dedup accountid | fillnull value=NULL | foreach tags.mms:account-owners,tags.mms:account-coach,tags.mms:infrastructure:support:email,tags.mms:technical-point-of-contact [eval <<FIELD>>=split(%27<<FIELD>>%27," ")] | search accountid="*" OR name="*" OR tags.mms:project="*" OR tags.mms:account-owners="*" OR tags.mms:account-ownership-org="*" OR tags.mms:account-coach="*" OR tags.mms:infrastructure:support:email="*" OR tags.mms:technical-point-of-contact="*" OR tags.mms:project="*" OR tags.mms:project-manager="*" OR accountalias="*" | rename tags.* as * | table accountid name accountalias mms:project mms:account-owners mms:account-ownership-org mms:account-coach mms:technical-point-of-contact mms:project-manager' -d output_mode=$format -d exec_mode=oneshot $extra_args 

exit $?

