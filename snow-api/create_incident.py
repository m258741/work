#!/usr/bin/python3
import pysnow
import json

# Create client object
c = pysnow.Client(instance='maximusdev', user='codeshuttle.user', password='kdndenU212!!8ebhehndeF')

# Define a resource, here we'll use the incident table API
incident = c.resource(api_path='/table/incident')
#change = c.resource(api_path='/table/change')

# Set the payload
fields_json = {
    'short_description': 'Pysnow created incident',
    'description': 'This is awesome'
}

# Create a new incident record
result = incident.create(payload=fields_json)

record = result.all()[0]
print(json.dumps(record))

inc_number = record['number']
print('incident created: ' + inc_number)
# Iterate over the result and print out `sys_id` of the matching records.
#for record in result.all():
#    #print(record['sys_id'])
#    print(json.dumps(record))
#    input('hit ret to proceed')
