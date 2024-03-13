#! /bin/bash

#. ~/.bashrc

destHost="srh01.east.splunk.logging.maximus.com"

if [[ "$1" == "" ]] ; then  
  if [[ "$SPLUNK_WEBMON_HASH" == "" ]] ; then    
    echo ${0}: Could not find auth hash.    
    exit 1  
  else    
    hash="$SPLUNK_SEARCH_HASH"  
  fi
else  
  hash="$1"
fi

search='search index=max_inventory source=aws:organizations sourcetype=account status=ACTIVE tags.mms:project!=*test* earliest=-24h (accountalias!="" AND accountalias!="unknown") | rename accountid as account_id | dedup account_id | rename organization_account_alias as organization | eval list="AWS Organizations Checker" | append [| inputlookup awsaccounts_description.csv | eval list="AWS Configured Accounts"] | eval onboarding_state=if(isnotnull(error_detail), 1, 0) | eventstats count by account_id | where onboarding_state=0 and count!=1 and accountalias!=""'

sid=$(curl -k -X POST https://${destHost}:8089/services/search/jobs -s \   
  -H "Authorization: Basic $hash" \
  -d search="$search" | grep '<sid>' | cut -d'>' -f2 | cut -d'<' -f1 2> /dev/null)

sleep 5

curl -k https://${destHost}:8089/services/search/jobs/$sid/results/ --get -s \
  -H "Authorization: Basic $hash" -d count=500 \
  -d output_mode=json | jq '.results[] | "\(.name) \(.object_id)"'

# EOF
