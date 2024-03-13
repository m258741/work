#!/bin/bash

# Usage: $0 inputfile.json outfile.csv

JSON_FILE=$1
OUTFILE=$2

fields=("ChangeID" "CreatedDateTime" "CreatedBy" "OwnedByManager" "OwnedByManagerEmail")
# loop thru array and create queries
for t in ${fields[@]}; do
  jqheaders+="\"$t\","
  jqfields+="(.fields[] | select(.name|test(\""$t"\")|.)|.value),"
done

# remove trailing comma
jqheaders=$(echo ${jqheaders%?})
jqfields=$(echo ${jqfields%?})

# Output rows to stdout for viewing
count=$(expr $(cat $JSON_FILE | jq '.businessObjects | length') - 1)
echo {} | jq -r "([$jqheaders] | (., map(length*\"-\"))) | @csv" | column -t
for i in $(eval echo "{0..$count}") ;do
    cat $JSON_FILE | jq  -r ".businessObjects["$i"] | [ $jqfields ] | @csv" | column -t
done

# create csv file
echo {} | jq -r "([$jqheaders] | (., map(length*\"-\"))) | @csv" | column -t > $OUTFILE
for i in $(eval echo "{0..$count}") ;do
    cat $JSON_FILE | jq  -r ".businessObjects["$i"] | [ $jqfields ] | @csv" | column -t >> $OUTFILE
done
exit 0
