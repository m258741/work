The following example shows how to create an Incident using PowerShell.

#-------------------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------------------

Function Set-FieldValue
{
    [CmdletBinding()]
    Param(
        [Parameter(Position=0, Mandatory=$True)]
            [PSCustomObject]$template
        ,[Parameter(Position=0, Mandatory=$True)]
            [String]$fieldName
        ,[Parameter(Position=0, Mandatory=$True)]
            [String]$value
    )

    $field = $template.fields | Where-Object {$_.name -eq $fieldName}

    if (!$field)
    {
        throw [System.Exception]"fieldName does not exist in template"
    }

    $field.value = $value
    $field.dirty = $true

}

#-------------------------------------------------------------------------------
# Logon to Service
#-------------------------------------------------------------------------------

# Set server login variables
$serverName = "your server"
$apiKey = "your client id"
$userName = "CSDAdmin"
$password = "CSDAdmin"
$baseUri = "http://${serverName}/CherwellAPI/"

# Get an access token
$tokenUri = $baseUri + "token"
$authMode = "Internal"
$tokenRequestBody =
@{
    "Accept" = "application/json";
    "grant_type" = "password";
    "client_id" = $apiKey;
    "username" = $userName;
    "password"= $password
}
$tokenResponse = Invoke-RestMethod -Method POST -Uri "${tokenUri}?auth_mode=${authMode}&api_key=${apiKey}" -Body $tokenRequestBody

$requestHeader = @{ Authorization = "Bearer $($tokenResponse.access_token)" }



#-------------------------------------------------------------------------------
# Get Customer Data
#-------------------------------------------------------------------------------

# Get the business object summary for customer internal
$summaryUri = $baseUri + "api/V1/getbusinessobjectsummary/busobname/CustomerInternal"
$summaryResults = Invoke-RestMethod -Method GET -Uri $summaryUri -ContentType application/json -Header $requestHeader
$busobId = $summaryResults[0].busobId

# Get the business object schema for customer interal
$schemaUri = $baseUri + "api/V1/getbusinessobjectschema/busobid/" + $busobId
$schemaResults = Invoke-RestMethod -Method GET -Uri $schemaUri -ContentType application/json -Header $requestHeader

# Get the fieldId for the Full Name field so we can use it for a search.
$fullNameField = $schemaResults.fieldDefinitions | Where-Object {$_.displayName -eq "Full name"}

# Create the search results request to lookup the customer and get the customers recid
$filterInfo =
@{
	fieldId = $($fullNameField.fieldId);
	operator = "eq";
	value = "Eric Cox"
}
$searchResultsRequest =
@{
	busObID = $busobId;
	filters = @($filterInfo)
} | ConvertTo-Json

# Run the search
$searchUri = $baseUri + "api/V1/getsearchresults"
$searchResponse = Invoke-RestMethod -Method POST -Uri $searchUri -ContentType application/json -Header $requestHeader -Body $searchResultsRequest

# Set the recid to be used in the creation of the incident
$customerRecId = $searchResponse.businessObjects[0].busObRecid

# Get the business object summary for incident
$summaryUri = $baseUri + "api/V1/getbusinessobjectsummary/busobname/Incident"
$summaryResponse = Invoke-RestMethod -Method GET -Uri $summaryUri -ContentType application/json -Header $requestHeader
$busobId = $summaryResponse[0].busobId



#-------------------------------------------------------------------------------
# Create a Business Object Template for BusObID for the specified criteria
#-------------------------------------------------------------------------------


# Create request for the business object template POST method
$getTemplateUri = $baseUri + "api/V1/GetBusinessObjectTemplate"
$templateRequest =
@{
    busObId = $busobId;
    includeRequired = $true;
    includeAll = $true
} | ConvertTo-Json
$templateResponse = Invoke-RestMethod -Method POST -Uri $getTemplateUri -Header $requestHeader -ContentType application/json -Body $templateRequest

# Set values in the template
Set-FieldValue -template $templateResponse -fieldName "Status" -value "New"
Set-FieldValue -template $templateResponse -fieldName "Description" -value "From Powershell using REST API"
Set-FieldValue -template $templateResponse -fieldName "ShortDescription" -value "New Incident"
Set-FieldValue -template $templateResponse -fieldName "CustomerRecID" $customerRecId
Set-FieldValue -template $templateResponse -fieldName "Priority" -value "2"
Set-FieldValue -template $templateResponse -fieldName "Source" -value "Phone"
Set-FieldValue -template $templateResponse -fieldName "IncidentType" -value "Incident"
Set-FieldValue -template $templateResponse -fieldName "Service" -value "Employee Support"
Set-FieldValue -template $templateResponse -fieldName "Category" -value "Add/Change"
Set-FieldValue -template $templateResponse -fieldName "Subcategory" -value "New Employee Setup"



#-------------------------------------------------------------------------------
# Create New Business Object
#-------------------------------------------------------------------------------

# Get the fields portion of the template and use it in the request for a new BO
$createBOUri = $baseuri + "api/V1/SaveBusinessObject"
$createBORequest =
@{
    busObId = $busobId;
    fields = @($($templateResponse.fields))
} | ConvertTo-Json

# Submit business object to server
$createBOResponse = Invoke-RestMethod -Method POST -Uri $createBOUri -Header $requestHeader -ContentType application/json -Body $createBORequest
