#!/usr/bin/python3
import pysnow
import json

# Create client object
c = pysnow.Client(instance='maximusdev', user='codeshuttle.user', password='kdndenU212!!8ebhehndeF')

# Define a resource, here we'll use the change request table API
change = c.resource(api_path='/table/change_request')
#change = c.resource(api_path='/table/change')

# States: 4=Cancelled, all else is 'New'?
# iterate 10 times
itr = 0
for i in range(10):
    itr += 1
    input('hit ret to create cr, state: ' + str(itr))
    # Set the payload
    fields_json = {
        'short_description': 'Pysnow created change request',
        'description': 'The PYSNOW API be working!',
        'state': itr,
        'type': 'standard',
        'category': 'standard',
        'sys_id': 'd52c2fa697d14e104546f027f053af55'
    }
    try:
        # skip error states:
        if itr == 3:
            continue
        # Create a new change record
        result = change.create(payload=fields_json)
    except Exception as e:
        print('error: ' + str(e))
        continue

    record = result.all()[0]
    #print(json.dumps(record))

    cr_number = record['number']
    print('cr created: ' + cr_number)

# Iterate over the result and print out `sys_id` of the matching records.
#for record in result.all():
#    #print(record['sys_id'])
#    print(json.dumps(record))
#    input('hit ret to proceed')
