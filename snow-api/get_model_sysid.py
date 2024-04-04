#!/usr/bin/python3
import pysnow
#from pysnow import Client, Table
import json

model_table_name = 'model'
model_name = 'chg_model'

# Create client object
c = pysnow.Client(instance='maximusdev', user='codeshuttle.user', password='kdndenU212!!8ebhehndeF')
client = c

# Specify the table where the model resides
model_table = client.table(model_table_name)
 
# Perform a query to retrieve the model sysid
# You can adjust the query parameters based on your specific requirements
#response = model_table.get(query={'name': model_name})

# fetch all:
response = model_table.get(query={})
 
# Extract the sysid from the response
if response and response.all():
    model_sysid = response.all()[0]['sys_id']
    print("Model SysID:", model_sysid)
else:
    print("Model not found.")
