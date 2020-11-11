function Get-GenesisLcmConfig {   
<#
.SYNOPSIS
Dynamically Generated API Function
.NOTES
NOT FOR PRODUCTION USE - FOR DEMONSTRATION/EDUCATION PURPOSES ONLY

The code samples provided here are intended as standalone examples.  They can be downloaded, copied and/or modified in any way you see fit.

Please be aware that all code samples provided here are unofficial in nature, are provided as examples only, are unsupported and will need to be heavily modified before they can be used in a production environment.
#>


<#
value: "{".oid":"LifeCycleManager",".method":"lcm_framework_rpc",".kwargs":{"method_class":"LcmFramework","method":"get_config"}}"

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

        [Parameter(Mandatory=$false)]
        [switch]
        $ShowMetadata,

        # Body Parameter1
        #[Parameter()]
        #$BodyParam1,

        # Prism UI Credential to invoke call
        [Parameter(Mandatory=$true)]
        [PSCredential]
        $Credential
    )

    process {
        #$body = [Hashtable]::new()
        #$body.add("BodyParam1",$BodyParam1)

        $payload = '{"value":"{\".oid\":\"LifeCycleManager\",\".method\":\"lcm_framework_rpc\",\".kwargs\":{\"method_class\":\"LcmFramework\",\"method\":\"get_config\"}}"}'
        

        $iwrArgs = @{
            Uri = "https://$($ComputerName):$($Port)/PrismGateway/services/rest/v1/genesis"
            Method = "POST"
            ContentType = "application/json"
        }
        <#if($body.count -ge 1){
            $iwrArgs.add("Body",($body | ConvertTo-Json))
        }#>

        #$body = $payload 
        $iwrArgs.add("Body",$payload)

        if($PSVersionTable.PSVersion.Major -lt 6){
            $basicAuth = Initialize-BasicAuthHeader -credential $Credential
            $iwrArgs.Add("headers",$basicAuth)
        }
        else{
            $iwrArgs.add("Authentication","Basic")
            $iwrArgs.add("Credential",$Credential)
            $iwrArgs.add("SkipCertificateCheck",$true)
            $iwrArgs.add("SslProtocol","Tls12")
        }
        
        $response = Invoke-WebRequest @iwrArgs

        if($response.StatusCode -eq 200){
            (($response.Content | ConvertFrom-Json).value | ConvertFrom-Json).'.return'
        }
        elseif($response.StatusCode -eq 401){
            Write-Verbose -Message "Credential used not authorized, exiting..."
            Write-Error -Message "$($response.StatusCode): $($response.StatusDescription)"
            exit
        }
        else{
            Write-Error -Message "$($response.StatusCode): $($response.StatusDescription)"
        }    

    }
                
}
