function Get-LicenseClusterSummaryFile {   
<#
.SYNOPSIS
Dynamically Generated API Function
.NOTES
NOT FOR PRODUCTION USE - FOR DEMONSTRATION/EDUCATION PURPOSES ONLY

The code samples provided here are intended as standalone examples.  They can be downloaded, copied and/or modified in any way you see fit.

Please be aware that all code samples provided here are unofficial in nature, are provided as examples only, are unsupported and will need to be heavily modified before they can be used in a production environment.
#>

    [CmdletBinding(DefaultParameterSetName='Online')]
    [OutputType()]

    param(
        # VIP or FQDN of target AOS cluster
        [Parameter(ParameterSetName = 'Online')]
        [Parameter(ParameterSetName = 'OutFile')]
        [Parameter(Mandatory=$true)]
        [string]
        $ComputerName,

        # Prism UI Credential to invoke call
        [Parameter(ParameterSetName = 'Online')]
        [Parameter(ParameterSetName = 'OutFile')]
        [Parameter(Mandatory=$true)]
        [PSCredential]
        $Credential,

        # Body Parameter1
        #[Parameter()]
        #$BodyParam1,

        [Parameter(ParameterSetName = 'Online')]
        [Parameter(ParameterSetName = 'OutFile')]
        [Parameter(Mandatory=$false)]
        [switch]
        $SkipCertificateCheck,

        [Parameter(ParameterSetName = 'OutFile')]
        [Parameter(Mandatory=$false)]
        [switch]
        $OutFile,

        [Parameter(ParameterSetName = 'OutFile')]
        [Parameter(Mandatory=$false)]
        [string]
        $OutFilePath,

        # Port (Default is 9440)
        [Parameter(ParameterSetName = 'Online')]
        [Parameter(ParameterSetName = 'OutFile')]
        [Parameter(Mandatory=$false)]
        [int16]
        $Port = 9440
    )

    begin {
        Set-StrictMode -Version Latest
    }

    process {
        $body = [Hashtable]::new()
        #$body.add("kind","kind")
        #$body.add("BodyParam1",$BodyParam1)

        $iwrArgs = @{
            Uri = "https://$($ComputerName):$($Port)/PrismGateway/services/rest/v1/license/cluster_summary_file"
            Method = "Get"
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
                #$content=@()
                [char[]]$content += $response.Content
                $json = $content -join '' | convertfrom-json -depth 50

                if($OutFile){
                    $OutFileName = (($response.headers.'content-disposition' -split ';')[1] -split '=')[1] -replace '"'
                    $json | convertto-json -Depth 50 | Out-File -FilePath $OutFilePath\$OutFileName -Encoding utf8
                }
                else{
                    $json
                }
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
