curl -o curl.out -w %{http_code} --location --request POST 'https://maximustest.cherwellondemand.com/CherwellAPI/token?api_key=3fa93948-f5b7-4d70-b364-f6dabab0564d' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Accept: application/json' \
--data 'grant_type=password&client_id=3fa93948-f5b7-4d70-b364-f6dabab0564d&username=Cherwell%5Csvc_TestAPIUser02&password=DuckWBDSDonald123!' 2>curl.err
