#!/usr/bin/python3
import pysnow
import json

# Create client object
client = pysnow.Client(instance='maximusdev', user='codeshuttle.user', password='kdndenU212!!8ebhehndeF')

#Get a standard change template sys_id:

try:
    # Specify the table and query parameters
    # THIS WAS TRICKY TO FIND: had to list all tables, and found std_change_template, which didn't match what AI gave me: change_template
    table = client.resource(api_path='/table/std_change_template')
    query_params = {'type': 'standard'}
    # Retrieve the sys_id of the standard change template
    response = table.get(query=query_params)
    # Extract the sys_id from the response
    if response and response.all():
        standard_change_templates = response.all()
        for template in standard_change_templates:
            print("Standard Change Template SysID:", template['sys_id'], template['name'])
            #print("Standard Change Template SysID:", template)
            #input("Press Enter to continue...")
    else:
        print("No standard change templates found.")
except Exception as e:
    print("An error occurred:", str(e))

