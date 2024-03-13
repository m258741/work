#!/bin/bash

# Usage: $0 inputfile.json outfile.csv

JSON_FILE=$1
OUTFILE=$2

fields=("ChangeID" "CreatedDateTime" "CreatedBy" "OwnedByManager" "OwnedByManagerEmail")

# loop thru array and create queries
for t in ${fields[@]}; do
  jqheaders+="\"$t\","
  jqfields+="(.fields[] | select(.name|test(\""$t"\")|.)|.value),"
  #jqfields+="(.businessObjects[${i}].fields[] | select(.name|test(\""$t"\")|.)|.value),"
done

# debug
echo "JQFIELDS: $jqfields"

# remove trailing comma
jqheaders=$(echo ${jqheaders%?})
jqfields=$(echo ${jqfields%?})

# Output rows to stdout for viewing
echo {} | jq -r "([$jqheaders] | (., map(length*\"-\"))) | @csv" | column -t
cat $JSON_FILE | jq  -r ". | [ $jqfields ] | @csv" | column -t

# create csv file
echo {} | jq -r "([$jqheaders] | (., map(length*\"-\"))) | @csv" | column -t > $OUTFILE
cat $JSON_FILE | jq  -r ". | [ $jqfields ] | @csv" | column -t >> $OUTFILE

exit 0

