#!/bin/bash

env="$1"
outFile="$2"
apiUrl="$3"

if [[ "$env" == "dev" ]] ; then
    #userName=Cherwell%5Csvc_TestAPIUser02
    # Load secure strings from .secrets
    #API_KEY="$(grep API_KEY_TEST .secrets | cut -f2 -d':' | base64 -d)"
    #API_PW="$(grep API_PW_TEST .secrets | cut -f2 -d':' | base64 -d)"
    # note: authHash is passed to the api base64 encoded (username:password)
    authHash="$(grep API_AUTH_HASH .secrets | cut -f2 -d':' )"
elif [[ "$env" == "prod" ]] ; then
    authHash="$(grep API_AUTH_HASH .secrets | cut -f2 -d':' )"
    #userName=Cherwell%5CSVC_CherAssetDecom
    # Load secure strings from .secrets
    #API_KEY="$(grep API_KEY_PROD .secrets | cut -f2 -d':' | base64 -d)"
    #API_PW="$(grep API_PW_PROD .secrets | cut -f2 -d':' | base64 -d)"
else
	echo "Error: invalid env specified."
	exit 1
fi

# Get auth token
#echo "API_PW: $API_PW"
#echo "API_KEY: $API_KEY"
#echo "USERNAME: $userName"
#authResponse=$(curl -X POST --silent --header "Content-Type: application/x-www-form-urlencoded" --header "Accept: application/json" -d "grant_type=password&client_id=${API_KEY}&username=$userName&password=${API_PW}" "$endPoint/token?api_key=${API_KEY}")
#export TOKEN=$(echo $authResponse | jq .access_token | sed 's/"//g')

# call API
curl -request GET --header "Authorization: Basic ${authHash}" \
"${apiUrl}" > $outFile
curlStatus=$?

echo "Wrote output file: $outFile"

# Exit w/ success or fail exit code
if [ $curlStatus -ne 0 ]; then
	exit 1
else
	exit 0
fi

