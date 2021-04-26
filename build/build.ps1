$OutPath = (Split-Path -path $PSScriptRoot)
$ModuleName = (Split-Path -path $OutPath -Leaf)

New-NtnxApiFunction -Method Get -ApiVersion v1 -AltVerb "Invoke" -AltNoun "NccCheck" -OutPath "$OutPath\$ModuleName\Public" -SubUrl "/ncc/checks"
New-NtnxApiFunction -Method Get -ApiVersion v1 -OutPath "$OutPath\$ModuleName\Public" -SubUrl "license"
New-NtnxApiFunction -Method Get -ApiVersion v1 -OutPath "$OutPath\$ModuleName\Public" -SubUrl "license/cluster_summary_file"