#!/usr/bin/python3
import pysnow
import json

# Create client object
c = pysnow.Client(instance='maximusdev', user='codeshuttle.user', password='kdndenU212!!8ebhehndeF')

# update this CR:
cr_number = 'CHG0030167'

# Define a resource, here we'll use the incident table API
cr = c.resource(api_path='/table/change_request')
#change = c.resource(api_path='/table/change')

update = {'short_description': 'New short description', 'state': 4}

# Update 'short_description' and 'state' for 'INC012345'
updated_record = cr.update(query={'number': cr_number}, payload=update)

# Print out the updated record
print(updated_record)
input('continue?')

# Create a new incident record
result = cr.create(payload=fields_json)

record = result.all()[0]
print(json.dumps(record))

cr_number = record['number']
print('cr created: ' + cr_number)
# Iterate over the result and print out `sys_id` of the matching records.
#for record in result.all():
#    #print(record['sys_id'])
#    print(json.dumps(record))
#    input('hit ret to proceed')
