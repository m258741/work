#!/bin/bash

spk_server="splunk.maximus.com"
spk_token="eyJraWQiOiJzcGx1bmsuc2VjcmV0IiwiYWxnIjoiSFM1MTIiLCJ2ZXIiOiJ2MiIsInR0eXAiOiJzdGF0aWMifQ.eyJpc3MiOiIyXzg3OTQ0IGZyb20gdXZhYXBtbXNyaDAxc3BrIiwic3ViIjoiYXBpX2NvZGVzaHV0dGxlIiwiYXVkIjoiY29kZXNodXR0bGUiLCJpZHAiOiJTcGx1bmsiLCJqdGkiOiI0NmY4NDVmNDE5MDFhMjQ2ZmVkYjNjZTQ4YmM0NzIyYTFhNTY4MGQwNWQ2ZjBlMTBhMTcwYTRmNWYzYjNlM2Q4IiwiaWF0IjoxNjY0MzEwMjIwLCJleHAiOjE2OTU4NDYyMjAsIm5iciI6MTY2NDMxMDIyMH0.0K26f4Qr5O_6dIz774anM5G7zjNlLZxIfVikLaDtgglNWF_225oDmHXifTjKG6EKReD5BLV6U9ndb4ha1ejIvA"
# default account, override on command line
aws_account="maximus-shared-env"

if [ "$1" != "" ]; then
  aws_account=$1
fi
curl -s -H "Authorization: Bearer $spk_token" https://$spk_server:8089/services/search/jobs \
-d search='| inputlookup aws_compliance_report.csv  | eval account_owner = split(account_owner," ")  | lookup aws_accounts_unmanaged accountalias as account_name OUTPUT managed  | search source IN (*) AND managed=y | eval result_recorded_time= strftime(strptime(result_recorded_time,"%25m/%25d/%25y %25H:%25M:%25S %25Z"), "%25m/%25d/%25y %25H:%25M:%25S") | search exclusion=false AND account_name IN ('"${aws_account}"') AND account_owner IN ("*") AND ((rule_name="*")) AND priority IN (1 3 5) AND region IN (*) AND managed=y | lookup insight_remediation_links.csv insight_name as rule_name | eval remediation="Remediation" | eval remediation_link=coalesce(remediation_link, rule_name) | rex mode=sed field="rule_name" "s/ManagedInstanceApplicationsRequired//g" | eval remediation_base = if(source="agentvalidation", "http://sphinx.logging.maximus.com/AgentValidation", "https://docs.ccoe.maximus.com/cloud-governance/compliance/remediations") | stats count by compliance_type | eventstats sum(count) as perCompliance | eval perCompliance=round(count*100/perCompliance,4) | where compliance_type="COMPLIANT" | table perCompliance' -d output_mode=json -d exec_mode=oneshot | jq .results[0].perCompliance  \
| tr -d '"'

exit $?

