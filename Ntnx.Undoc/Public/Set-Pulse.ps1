function Set-Pulse {
<#
.SYNOPSIS
Set Pulse via API to configure the same settings manually typed into 

Dynamically Generated API Function
.NOTES
NOT FOR PRODUCTION USE - FOR DEMONSTRATION/EDUCATION PURPOSES ONLY
#>

    [CmdletBinding()]

    param (
        # Cluster FQDN
        [Parameter(Mandatory=$true)]
        [string]
        $ComputerName,

        [Parameter()]
        [bool]
        $RemindLater = $false,

        [Parameter()]
        [string[]]
        $EmailContactList,

        [Parameter()]
        [String]
        $DefaultNutanixEmail = "nos-asups@nutanix.com",

        [Parameter(Mandatory=$true)]
        [bool]
        $Enable,

        [Parameter()]
        [bool]
        $EnableDefaultNutanixEmail = $false,

        [Parameter()]
        [bool]
        $IsPulsePromptNeeded = $false,

        [Parameter()]
        [ValidateSet("ALL","AUTO","PARTIAL")]
        [String]
        $IdentificationInfoScrubbingLevel,

        [Parameter()]
        $NosVersion,

        [Parameter()]
        [ValidateSet("BASIC_COREDUMP")]
        [string]
        $VerbosityType = "BASIC_COREDUMP",

        [Parameter(Mandatory=$true)]
        [PSCredential]
        $Credential,

        [Parameter(Mandatory=$false)]
        [switch]
        $PcFanOut,

        [Parameter(Mandatory=$false)]
        [int16]
        $port = 9440
    )

    process {
        $body = @{
            #remindLater = $RemindLater
            enable = $Enable
            #verbosityType = $VerbosityType
            #emailContactList = $EmailContactList
            #defaultNutanixEmail = $DefaultNutanixEmail
            #enableDefaultNutanixEmail = $EnableDefaultNutanixEmail
            isPulsePromptNeeded = $IsPulsePromptNeeded
            identificationInfoScrubbingLevel = $IdentificationInfoScrubbingLevel
        }

        #$body = [v1TiaaNtnxPulse]::new()
        [string]$body = $body | ConvertTo-Json

        $headers = Initialize-BasicAuthHeader -credential $Credential
        $headers.Add("content-type", "application/json")

        $url = "https://$($ComputerName):$($port)/PrismGateway/services/rest/v1/pulse"
        if($PcFanOut){
            $url = $url + "?proxyClusterUuid=all_clusters"
        }
        
        $response = Invoke-RestMethod -Method PUT -Uri $url -Headers $headers -Body $body

        Write-Output $response
    }
        
}