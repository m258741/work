#!/usr/bin/python3
import sys
import pysnow
import json
import requests

# Create client object
#c = pysnow.Client(instance='maximusdev', user='codeshuttle.user', password='kdndenU212!!8ebhehndeF')
user='codeshuttle.user'
pwd='kdndenU212!!8ebhehndeF'

# Define parameters for the standard change request
#table = '/change_request'
#table = '/change/standard'
 
# Specify the CR Template to use
cr_template_id = 'c136b71a974902104546f027f053af35 '
# Set the HTTP headers
headers = {"Content-Type":"application/json","Accept":"application/json"}
# Authenticate and create a session
session = requests.Session()
session.auth = (user, pwd)
# Step 2: Retrieve the details of the specified CR Template
cr_template_url = f'https://maximusdev.service-now.com/api/now/table/cr_template/{cr_template_id}'
response = session.get(cr_template_url, headers=headers)

print("Response:", response)
 
# Check if the request was successful
if response.status_code == 200:
    cr_template_data = response.json()['result']
    # Extract necessary information from the CR Template data
    # Example: Extracting the name and description of the CR Template
    cr_template_name = cr_template_data.get('name')
    cr_template_description = cr_template_data.get('description')
 
    # Step 3: Create a new change request based on the retrieved CR Template

    # Example payload for creating a new change request

    payload = {

        "type": "standard",

        "template_id": cr_template_id,

        "short_description": f"Change request based on {cr_template_name}",

        "description": f"Change request based on {cr_template_description}",

        # Add any other necessary fields based on your requirements

    }

    sys.exit(0)
 
    # Make the POST request to create the change request

    response = session.post(url, json=payload, headers=headers)
 
    # Check if the request was successful

    if response.status_code == 201:

        print("Change request created successfully.")

    else:

        print("Failed to create change request:", response.status_code)

else:

    print("Failed to retrieve CR Template details:", response.status_code)
 