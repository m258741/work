import json
import pymongo

# MongoDB connection settings
mongo_uri = "mongodb://mongodb.codeshuttle.maximus.com:27017"  # Replace with your MongoDB URI
database_name = "dev_test"      
jobs_collection_name = "jobs_dev"  
sbom_collection_name = "sbom_processed_dev"  

# Connect to MongoDB
client = pymongo.MongoClient(mongo_uri)
db = client[database_name]
# create client connection to jobs collection
jobs_collection = db[jobs_collection_name]
# create client connection to sbom collection
sbom_collection = db[sbom_collection_name]

# Define your find and sort criteria
#jobs_query = {"customerName": "maximus-miha", "environment": "uat1", "job.revision": "483"}  # Your find query
jobs_query = {"customerName": "maximus-miha", "environment": "BADENV", "job.revision": "483"}  # Your find query
sort_query = [("_id", pymongo.DESCENDING)]  # Sort by "_id" field in descending order

# Query and sort jobs documents
cursor = jobs_collection.find(jobs_query).sort(sort_query).limit(1)
print('cursor:')
print(cursor)

quit()

# Collect documents in a list
jobs_list = [doc for doc in cursor]
#print('type(documents):')
#print(type(documents))

# get json str from documents list
#jobs_json = json.dumps(documents, default=str)

# print object type of jobs_json
#print('type(jobs_json):')
#print(type(jobs_json))
# Print jobs_json 
#print('jobs_json:')
#print(jobs_json)

# extract each sbom uuid from each sbomUIIDs
#jobs_list = json.loads(jobs_json)
#print('type(jobs_list):')
#print(type(jobs_list))
#sbom_list = list(sbom_array)
for job in jobs_list:
    print('job:')
    print(job)
    sbomUUIDs = job['sbomUUIDs']
    for uuid in sbomUUIDs:
        print('uuid:')
        print(uuid)
        # create query string to get the bom-ref from sbom collection
        sbom_query = {"metadata.component.bom_ref": uuid}
        print('sbom_query:')
        print(sbom_query)
        # query sbom collection
        cursor = sbom_collection.find(sbom_query).sort(sort_query)
        print('cursor:')
        print(cursor)
        # collect documents in a list
        sbom_documents = [doc for doc in cursor]
        #print('sbom documents:')
        #print(sbom_documents)
        # convert the list to a JSON array
        sbom_json = json.dumps(sbom_documents, default=str, indent=4)
        print('sbom_json:')
        print(sbom_json)




# iterate over sbom_list 
#for sbom in sbom_list:
    #print(sbom)
    #bom_ref = sbom['job']['bomRef']
    #print(bom_ref)
    #sbom_query = {"metadata.component.bom_ref": bom_ref}  
    #print(sbom_query)
    #cursor = sbom_collection.find(sbom_query).sort(sort_query).limit(1)
    #print(cursor)
    #documents = [doc for doc in cursor]
    #print(documents)
    #json_str = json.dumps(documents, default=str)
    #print(json_str)
    #sbom_array = json.loads(json_str)
    #print(sbom_array)
    #sbom_list = list(sbom_array)
    #print(sbom_list)
    #for sbom in sbom_list:
    #    print(sbom)
    #    print(sbom['metadata']['component']

# create query string to get the bom-ref from sbom collection
#sbom_query = {"metadata.component.bom_ref": "maximus-miha"}  

    
#for sbom in sbom_array:
#    print(sbom)
    #bom_ref = sbom['job']['bomRef']

# For each sbom, pull the vulnerabilities from sbom collection

# return results - how?

# Iterate over the results
#for document in cursor:
#  print(document)

# Close the MongoDB connection
client.close()
