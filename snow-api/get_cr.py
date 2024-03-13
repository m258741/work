#!/usr/bin/python3
import pysnow
import json

# Create client object
c = pysnow.Client(instance='maximusdev', user='codeshuttle.user', password='kdndenU212!!8ebhehndeF')

# Define a resource, here we'll use the incident table API
obj = c.resource(api_path='/table/change_request')
#change = c.resource(api_path='/table/change')

# Query for incidents with state 1
#response = incident.get(query={})

change_number='CHG0030165'

qb = (
    pysnow.QueryBuilder()
    .field('number').equals(change_number)
    )

response = obj.get(query=qb)
#response = change.get(query={'state': 1})

# Iterate over the result and print out `sys_id` of the matching records.
for record in response.all():
    #print(record['sys_id'])
    print(json.dumps(record))
    #print(record['number'],record['sys_created_by'])
    input('hit ret to proceed')
