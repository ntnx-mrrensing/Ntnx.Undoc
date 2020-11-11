function New-EulasAccept {
<#
.SYNOPSIS
Dynamically Generated API Function

.NOTES
NOT FOR PRODUCTION USE - FOR DEMONSTRATION/EDUCATION PURPOSES ONLY

The code samples provided here are intended as standalone examples.  They can be downloaded, copied and/or modified in any way you see fit.

Please be aware that all code samples provided here are unofficial in nature, are provided as examples only, are unsupported and will need to be heavily modified before they can be used in a production environment.
#>

    [cmdletbinding()]

    param (
        [Parameter(Mandatory=$true)]
        [string]
        $ComputerName,

        [Parameter(Mandatory=$false)]
        [int16]
        $Port = 9440,

        [Parameter(Mandatory=$true)]
        [string]
        $Username,

        [Parameter(Mandatory=$true)]
        [string]
        $CompanyName,

        [Parameter(Mandatory=$true)]
        [string]
        $JobTitle,

        [Parameter(Mandatory=$true)]
        [PSCredential]
        $Credential
    )

    process {
        $body = @{
            username = $Username
            companyName = $CompanyName
            jobTitle = $JobTitle
        }

        [string]$body = $body | ConvertTo-Json

        $headers = Initialize-BasicAuthHeader -credential $Credential
        $headers.Add("content-type", "application/json")

        $url = "https://$($ComputerName):$($port)/PrismGateway/services/rest/v1/eulas/accept"
        
        $response = Invoke-RestMethod -Method POST -Uri $url -Headers $headers -Body $body

        Write-Output $response
    }
               
}