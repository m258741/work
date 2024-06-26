#!/usr/bin/python3
import pysnow
import json

# Create client object
client = pysnow.Client(instance='maximusdev', user='codeshuttle.user', password='kdndenU212!!8ebhehndeF')

# Specify the table from which you want to select rows
#selected_table = 'chg_model'
selected_table = 'std_change_record_producer_list'

 
# Get rows from the selected table
response = client.resource(api_path='/table/{}'.format(selected_table)).get()
 
# Extract data from the response
if response and response.all():
    rows = response.all()
    # Print or process the rows as needed
    for row in rows:
        print(row)
