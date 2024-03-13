curl --location --request POST 'https://cherwell-api-test.se.maximus.com/stdChange/dateQuery' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJjaGVyd2VsbGFwaS10ZXN0IiwiaWF0IjoxNjUwOTI1ODQ5LCJleHAiOjE2NTA5MjY0NDl9.1zPEXMkTdwdy_33zq_yMppalN7CuaM5mRtlbHuL0mCNUwFuMNF-nZsstVtA2F2MDIDPJ-a2FfLF-vhJIKNdH0g' \
--data-raw '{
    "startDate": "12/11/2021 01:00",
    "endDate": "03/08/2022 23:59"
}'
