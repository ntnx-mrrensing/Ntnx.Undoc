function Invoke-NccCheck {  
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
        [string]
        $ComputerName,

        [Parameter(Mandatory=$false)]
        [int16]
        $port = 9440,

        [Parameter()]
        [bool]
        $sendEmail = $false,
        
        [Parameter(Mandatory=$true)]
        [int[]]
        $CheckID,

        [Parameter(Mandatory=$true)]
        [PSCredential]
        $Credential
    )

    PROCESS {

        $body = @{
            sendEmail = $sendEmail
            nccChecks = $CheckID.foreach({$_.ToString()})
        }
        
        $body = $body | ConvertTo-Json
        Write-Verbose -Message "JSON Payload: $body"

        $headers = Initialize-BasicAuthHeader -credential $Credential
        $headers.Add("content-type", "application/json")

        $url = "https://$($ComputerName):$($Port)/PrismGateway/services/rest/v1/ncc/checks"
        
        $response = Invoke-RestMethod -Method POST -Uri $url -Headers $headers -Body $body
        $response | add-member -Name ComputerName -Value $ComputerName -MemberType NoteProperty

        Write-Output $response

    }
        
        
}
