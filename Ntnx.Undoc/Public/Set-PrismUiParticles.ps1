function Set-PrismUiParticles { 
<#
.SYNOPSIS
Set Prism UI Particle Effect

Dynamically Generated API Function
.NOTES
NOT FOR PRODUCTION USE - FOR DEMONSTRATION/EDUCATION PURPOSES ONLY

The code samples provided here are intended as standalone examples.  They can be downloaded, copied and/or modified in any way you see fit.

Please be aware that all code samples provided here are unofficial in nature, are provided as examples only, are unsupported and will need to be heavily modified before they can be used in a production environment.
#>
    
    [CmdletBinding()]

    param(
        [Parameter(Mandatory=$true)]
        [string]
        $ComputerName,

        [Parameter(Mandatory=$false)]
        [int16]
        $port = 9440,

        # Value Enables ($false) or Disables ($true) particle effect; Disable ($true) is the default setting
        [Parameter()]
        [bool]
        $Value = $true,

        [Parameter(Mandatory=$true)]
        [PSCredential]
        $Credential
    )

    process {
        $body = @{
            type = "WELCOME_BANNER"
            key = "disable_video"
            value = $value
        }

        $body = $body | ConvertTo-Json

        $headers = Initialize-BasicAuthHeader -credential $Credential
        $headers.Add("content-type", "application/json")

        $url = "https://$($ComputerName):$($port)/PrismGateway/services/rest/v1/application/system_data"
        
        $response = Invoke-RestMethod -Method PUT -Uri $url -Headers $headers -Body $body

        Write-OutPut $response
    }
        
        
}
