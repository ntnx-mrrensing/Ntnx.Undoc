function Set-UtilsChangeDefaultSystemPassword {
<#
.SYNOPSIS
Change Default Prism UI Password, typically as needed after creating a new cluster

Dynamically Generated API Function
.NOTES
NOT FOR PRODUCTION USE - FOR DEMONSTRATION/EDUCATION PURPOSES ONLY

The code samples provided here are intended as standalone examples.  They can be downloaded, copied and/or modified in any way you see fit.

Please be aware that all code samples provided here are unofficial in nature, are provided as examples only, are unsupported and will need to be heavily modified before they can be used in a production environment.
#>

    [CmdletBinding()]
    [OutputType()]

    param(
        [Parameter(Mandatory=$true)]
        [string]
        $ComputerName,

        [Parameter(Mandatory=$false)]
        [int16]
        $port = 9440,

        [Parameter(Mandatory=$true)]
        [string]
        $OldPassword,

        [Parameter(Mandatory=$true)]
        [string]
        $NewPassword,

        [Parameter(Mandatory=$true)]
        [PSCredential]
        $Credential
    )

    process{
        #$body = [v1TiaaNtnxPasswordChange]::new($oldPassword,$newPassword)
        $body = [hashtable] @{
            oldPassword = $oldPassword
            newPassword = $newPassword
        }

        $body = $body | ConvertTo-Json

        $headers = Initialize-BasicAuthHeader -credential $Credential
        $headers.Add("content-type", "application/json")

        $url = "https://$($ComputerName):$($port)/PrismGateway/services/rest/v1/utils/change_default_system_password"
        
        #$response = Invoke-RestMethod -Method POST -Uri $url -Headers $headers -Body $body
        $response = Invoke-WebRequest -Method POST -Uri $url -Headers $headers -Body $body      
        #$response = Invoke-WebRequest @args 

        if($response.StatusCode -eq 200){
            $response.Content | ConvertFrom-Json
        }   
        else{
            Write-Error -Message "$($response.StatusCode): $($response.StatusDescription)"
        }    
    }
}
