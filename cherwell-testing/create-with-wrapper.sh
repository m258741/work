#!/bin/bash

set -x

curl -H "Content-Type: application/json" -d '{"username":"cherwellapi-test","password":"CherwellAPI-t0i$5Ktt"}' https://cherwell-api-test.se.maximus.com/authenticate > /tmp/token

echo "TOKEN:"
cat /tmp/token
TOKEN=`cat /tmp/token | cut -f2 -d':' | tr -d '"' | sed -e 's/}$//'`

echo "TOKEN:"
echo "$TOKEN"

#STARTDATE="11/01/2021 22:00"
#ENDDATE="11/01/2021 22:01"

#TOKEN="eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJjaGVyd2VsbGFwaS10ZXN0IiwiaWF0IjoxNjM1Nzg3MTEzLCJleHAiOjE2MzU3ODc3MTN9.PK3OoXOlduV8V2QUnGbFZAL6RSnrC1pGDM_dZVy-llWTUrCvNK2ljwKAMQRu7L8-abEQXKsiGKrlxvRiBi0X6A"

sleep 3

#curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" -d '{"requesterId":"258741","ownerId":"258741","customer":"Connection Point","priority":"Low","impact":"Individual","urgency":"Optional Service","title":"Deploy COEB 4.0.4 to TEST","description":"Deploy COEB to dev Environment","template":"Infrastructure Operation Systems","templateItem":"Solarwinds Agent Installation","scheduledStartDate":"11/01/2021 2:00 PM","scheduledEndDate":"11/01/2021 2:01 PM","targetEnv":"dev","scope":"low"}' https://cherwell-api-test.se.maximus.com/stdChange/create

# with 'customer', "Databases" template item:
#curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" -d '{"requesterId":"258741","ownerId":"258741","customer":"Connection Point","priority":"Low","impact":"Individual","urgency":"Optional Service","title":"Deploy COEB 4.0.4 to TEST","description":"Deploy COEB to dev Environment","template":"Infrastructure Operation Systems","templateItem":"Decommissions for Databases","scheduledStartDate":"11/01/2021 2:00 PM","scheduledEndDate":"11/01/2021 2:01 PM","targetEnv":"dev","scope":"low"}' https://cherwell-api-test.se.maximus.com/stdChange/create
#
# remove 'customer', change 24h date format:
#curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" -d '{"requesterId":"258741","ownerId":"258741","priority":"Low","impact":"Individual","urgency":"Optional Service","title":"Deploy COEB 4.0.4 to TEST","description":"Deploy COEB to dev Environment","template":"Infrastructure Operation Systems","templateItem":"Decommissions for Databases","scheduledStartDate":"11/01/2021 22:00","scheduledEndDate":"11/01/2021 22:01","targetEnv":"dev","scope":"low"}' https://cherwell-api-test.se.maximus.com/stdChange/create
#
# WORKS - 24h date forat, Solarwinds templateITem:
curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" -d '{"requesterId":"258741","ownerId":"258741","priority":"Low","impact":"Individual","urgency":"Optional Service","title":"Deploy COEB 4.0.4 to TEST","description":"Deploy COEB to dev Environment","template":"Infrastructure Operation Systems","templateItem":"Solarwinds Agent Installation","scheduledStartDate":"11/01/2021 22:00","scheduledEndDate":"11/01/2021 22:01","targetEnv":"dev","scope":"low"}' https://cherwell-api-test.se.maximus.com/stdChange/create


