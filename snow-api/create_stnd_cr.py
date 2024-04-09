#!/usr/bin/python3
import pysnow
import json

# Create client object
c = pysnow.Client(instance='maximusdev', user='codeshuttle.user', password='kdndenU212!!8ebhehndeF')

# Define a resource, here we'll use the change request table API
#change = c.resource(api_path='/table/change_request')
#change = c.resource(api_path='/table/change_request/standard/6d07efd897d146104546f027f053af1f')

# Define parameters for the standard change request
#table = '/change_request'
table = '/change/standard'
short_description = 'Short description of the change'
description = 'Detailed description of the change'
change_type = 'Standard'
#change_type = 'standard'
#state = 'Draft'  # Set initial state
state = 'New'  # Set initial state
assignment_group = 'SG-SN Automated Process'  # Set assignment group
 
# Create a dictionary with the parameters
#change_params = {
#    'short_description': short_description,
#    'description': description,
#    'type': change_type,
#    'state': state,
#    'assignment_group': assignment_group
#}
change_params = {
    'type': change_type,
    'assignment_group': assignment_group
}
 
# Create the standard change request
response = c.resource(api_path=table).create(payload=change_params)
 
print("Response:", response)

# Check if the request was successful
if response.status_code == 201:
    print("Standard change request created successfully!")
    print("Change Request Number:", response.json()['result']['number'])
else:
    print("Failed to create standard change request. Status code:", response.status_code)
    print("Error:", response.text)
