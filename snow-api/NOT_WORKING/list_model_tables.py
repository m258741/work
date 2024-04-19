#!/usr/bin/python3
import pysnow
import json
#from pysnow import Client, Table

# Create client object
c = pysnow.Client(instance='maximusdev', user='codeshuttle.user', password='kdndenU212!!8ebhehndeF')
client = c

# Get a list of all tables
tables = client.tables()
 
# Filter out tables that are likely to be model tables
model_tables = [table for table in tables if 'model' in table or 'classification' in table]
 
# Print the list of model tables
print("Model Tables:")
for table in model_tables:
    print(table)
