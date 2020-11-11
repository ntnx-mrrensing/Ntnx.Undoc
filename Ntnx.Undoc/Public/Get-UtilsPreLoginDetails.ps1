function Get-UtilsPreLoginDetails {   
<#
.SYNOPSIS
Dynamically Generated API Function
.NOTES
NOT FOR PRODUCTION USE - FOR DEMONSTRATION/EDUCATION PURPOSES ONLY

The code samples provided here are intended as standalone examples.  They can be downloaded, copied and/or modified in any way you see fit.

Please be aware that all code samples provided here are unofficial in nature, are provided as examples only, are unsupported and will need to be heavily modified before they can be used in a production environment.
#>

    [CmdletBinding()]
    [OutputType()]

    param(
        # VIP or FQDN of target AOS cluster
        [Parameter(Mandatory=$true)]
        [string]
        $ComputerName,

        # Port (Default is 9440)
        [Parameter(Mandatory=$false)]
        [int16]
        $Port = 9440,

        # Port (Default is 9440)
        [Parameter(Mandatory=$false)]
        [string]
        $CharSet = "UTF-8",

        # Prism UI Credential to invoke call
        [Parameter(Mandatory=$false)]
        [PSCredential]
        $Credential
    )

    process {
        $connectionTest = test-connection -ComputerName $ComputerName -Count 3 -Quiet
        if(!$connectionTest){
            Write-Error -Message "Host $ComputerName Unreachable"
            exit
        }

        $args = @{
            Method = "GET"
            Uri = "https://$($ComputerName):$($Port)/PrismGateway/services/rest/v1/utils/pre_login_details"
            ContentType = "application/json"
        }

        
        if(!$Credential){
            Write-Verbose -Message "Credential is empty"
        }
        else{
            Write-Verbose -Message "Adding Basic Auth to Headers"
            $args.Add("headers",(Initialize-BasicAuthHeader -credential $Credential))
        }

        $response = Invoke-WebRequest @args 

        if($response.StatusCode -eq 200){
            $response.Content | ConvertFrom-Json
        }   
        else{
            Write-Error -Message "$($response.StatusCode): $($response.StatusDescription)"                                                      
        }
    }                    
}