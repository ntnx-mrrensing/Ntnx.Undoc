function Invoke-NccCheck {   
<#
.SYNOPSIS
Dynamically Generated API Function
.NOTES
NOT FOR PRODUCTION USE - FOR DEMONSTRATION/EDUCATION PURPOSES ONLY

The code samples provided here are intended as standalone examples.  They can be downloaded, copied and/or modified in any way you see fit.

Please be aware that all code samples provided here are unofficial in nature, are provided as examples only, are unsupported and will need to be heavily modified before they can be used in a production environment.
#>

    [CmdletBinding(DefaultParameterSetName='All')]
    [OutputType()]

    param(
        # VIP or FQDN of target AOS cluster
        [Parameter(Mandatory=$true)]
        [string]
        $ComputerName,

        # Prism UI Credential to invoke call
        [Parameter(Mandatory=$true)]
        [PSCredential]
        $Credential,

        [Parameter(Mandatory=$true,
                   ParameterSetName="Select")]
        [int[]]
        $CheckID,

        [Parameter(ParameterSetName="All")]
        [Parameter(ParameterSetName="Select")]
        [switch]
        $SendEmail,
        
        [Parameter(Mandatory=$false)]
        [switch]
        $SkipCertificateCheck,

        # Port (Default is 9440)
        [Parameter(Mandatory=$false)]
        [int16]
        $Port = 9440
    )

    begin {
        Set-StrictMode -Version Latest
    }

    process {
        $body = [Hashtable]::new()
        $body.add("sendEmail",$false)

        if ($SendEmail) {
            $body.sendEmail = $true
        }

        if ($PSCmdlet.ParameterSetName -eq "Select") {
            Write-Verbose -Message "$($PSCmdlet.ParameterSetName)"
            $body.add("nccChecks",$CheckID.foreach({$_.ToString()}))
        }

        $iwrArgs = @{
            Uri = "https://$($ComputerName):$($Port)/PrismGateway/services/rest/v1/ncc/checks"
            Method = "POST"
            ContentType = "application/json"
            ErrorVariable = "iwrError"
        }

        if($body.count -ge 1){
            $iwrArgs.add("Body",($body | ConvertTo-Json))
        }

        if($PSVersionTable.PSVersion.Major -lt 6){
            $basicAuth = Initialize-BasicAuthHeader -credential $Credential
            $iwrArgs.Add("headers",$basicAuth)
        }
        else{
            $iwrArgs.add("Authentication","Basic")
            $iwrArgs.add("Credential",$Credential)
            $iwrArgs.add("SslProtocol","Tls12")

            if($SkipCertificateCheck){
                $iwrArgs.add("SkipCertificateCheck",$true)
            }
        }
        
        try{
            $response = Invoke-WebRequest @iwrArgs

            if($response.StatusCode -in 200..204){
                $content = $response.Content | ConvertFrom-Json
                $content
            }
        } 
        catch{
            if($null -eq $iwrError){
                Write-Error -Message "API Call Failed"
            }
            else{
                Write-Error -Message $iwrError.Message
            }
        }
    }
                
}
