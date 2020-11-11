
function Get-NccCheckResults {
    
    <#
    .SYNOPSIS
    Dynamically Generated API Function
    .NOTES
    NOT FOR PRODUCTION USE - FOR DEMONSTRATION/EDUCATION PURPOSES ONLY
    
    The code samples provided here are intended as standalone examples.  They can be downloaded, copied and/or modified in any way you see fit.
    
    Please be aware that all code samples provided here are unofficial in nature, are provided as examples only, are unsupported and will need to be heavily modified before they can be used in a production environment.
    #>
    

    [cmdletbinding()]

    PARAM (
    
        [Parameter(Mandatory=$true)]
        [Alias("Cluster")]
        [string]
        $ComputerName,

        [Parameter(Mandatory=$false)]
        [int16]
        $Port = 9440,

        [Parameter(Mandatory=$true)]
        [string]
        $TaskUuid,

        [Parameter(Mandatory=$true)]
        [PSCredential]
        $Credential

    )

    PROCESS {

        $headers = Initialize-BasicAuthHeader -credential $Credential
        $headers.Add("content-type", "application/json")

        $url = "https://$($ComputerName):$($port)/PrismGateway/services/rest/v1/ncc/$($taskUuid)"
        
        $response = Invoke-RestMethod -Method Get -Uri $url -Headers $headers

        Write-Output $response

    }
        
        
}
