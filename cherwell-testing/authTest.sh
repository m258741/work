endPoint="https://maximustest.cherwellondemand.com/CherwellAPI"
userName=Cherwell%5Csvc_TestAPIUser02
API_KEY="$(grep API_KEY_TEST .secrets | cut -f2 -d':' | base64 -d)"
API_PW="$(grep API_PW_TEST .secrets | cut -f2 -d':' | base64 -d)"
echo $API_KEY
echo $API_PW
set -x
curl -X POST --silent --header "Content-Type: application/x-www-form-urlencoded" --header "Accept: application/json" -d "grant_type=password&client_id=${API_KEY}&username=$userName&password=${API_PW}" "${endPoint}/token?api_key=${API_KEY}" > /tmp/out

echo "see /tmp/out"
