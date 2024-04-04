#!/usr/bin/python3
import pysnow
import json
import sys

# if no command line arg, error and exit
if len(sys.argv) < 2: 
    print('Usage: get_incident.py <incident number>')
    sys.exit(1)

# load incident number from command line
number = sys.argv[1]

# Create client object
c = pysnow.Client(instance='maximusdev', user='codeshuttle.user', password='kdndenU212!!8ebhehndeF')

# Define a resource, here we'll use the incident table API
incident = c.resource(api_path='/table/incident')
#change = c.resource(api_path='/table/change')

qb = (
     pysnow.QueryBuilder()
     .field('number').equals(number)
     )

# Query for incidents with state 1
#response = incident.get(query={})
response = incident.get(query=qb)
#response = change.get(query={'state': 1})

# Iterate over the result and print out `sys_id` of the matching records.
for record in response.all():
    #print(record['sys_id'])
    print(json.dumps(record))
    input('hit ret to proceed')
