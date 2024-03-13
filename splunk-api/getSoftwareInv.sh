#!/bin/bash

spk_server="splunk.maximus.com"
spk_token="`cat .token | base64 -d`"
# default account, override on command line
out_fmt="csv"
page_count="500"

search='|  inputlookup sw_inventory_parsing_v2.csv | search package = "*" 
| eval AWS_Account=if((location like "%25aws"),AWS_Account,"not_aws" )
| eval environment=if((location like "%25aws"),environment,"unknown") 
| eval pkg_support = if((EOL like "%2520%25"),pkg_support,"unknown") 
| search package = "*" version="*" location="*" SRC="*" AWS_Account="*" environment="*" pkg_support="*" project = "*" division = "*" tags_it_support_model="*" 
| table AWS_Account owner project division environment package version ipaddress endofLife SRC pkg_support EOL hostname instanceid AWS_ID package_version location tags_it_support_model 
| eval futuredate = strptime(relative_time(now(), "+2mon"),"%25Y-%25m-%25d") 
| eval futuredate = strftime(futuredate, "%25Y-%25m-%25d") 
| where package IN ("win","linux") | dedup ipaddress package 
| stats count BY project,tags_it_support_model,division,owner,package_version,endofLife 
| eval host_count = count 
| sort project,-host_count 
| table project package_version host_count endofLife owner'

# strip newlines from search string
search="$(echo $search | tr -d '\n')"

#echo "SEARCH: $search"
curl -s -H "Authorization: Bearer $spk_token" https://$spk_server:8089/services/search/jobs \
-d search="$search" -d output_mode=$out_fmt -d exec_mode=oneshot -d count=$page_count
exit 0
#-d search="'""$search""'"

-d output_mode=$out_fmt -d exec_mode=oneshot 

exit $?

