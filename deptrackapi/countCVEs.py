import requests
import json

#api_url = "https://your-dependency-track-api-url/api/v1/projects"  # Replace with the actual API endpoint
api_url = "https://dependency-track-maximus-tlowe-dev.se.maximus.com/api/v1/vulnerability"
api_key = "xfiuTZ0WrPn6WoixWDxzEjFeK4AC9nRb"

headers = {
    "X-API-Key": api_key
    }


response = requests.get(api_url, headers=headers)
print("Response")
print(response)
# data is a 'list'
data = response.json()

myjson = json.dumps(data)

print('data: ' )
print(type(data))
print(data)
print('json: ' )
print(type(myjson))
print(myjson)

for vulns in myjson.vulnId:
    for key, value in vulns.iteritems():
            print key, 'is:', value

total_items = data.get("totalCount", 0)  # Adjust the field name according to actual API response
items_per_page = data.get("itemsPerPage", 10)  # Adjust the field name according to actual API response

total_pages = (total_items + items_per_page - 1) // items_per_page

print("Total Pages:", total_pages)

