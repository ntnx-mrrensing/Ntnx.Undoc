$OutPath = (Split-Path -path $PSScriptRoot)
$ModuleName = (Split-Path -path $OutPath -Leaf)

New-NtnxApiFunction -Method POST -ApiVersion v1 -OutPath "$OutPath\$ModuleName\Public" -SubUrl "/ncc/checks" -AltVerb "Invoke" -AltNoun "NccCheck"
New-NtnxApiFunction -Method GET -ApiVersion v1 -OutPath "$OutPath\$ModuleName\Public" -SubUrl "/license"
New-NtnxApiFunction -Method Get -ApiVersion v1 -OutPath "$OutPath\$ModuleName\Public" -SubUrl "license/cluster_summary_file"
New-NtnxApiFunction -Method GET -ApiVersion v1 -OutPath "$OutPath\$ModuleName\Public" -SubUrl "ncc/$($taskUuid)" -AltNoun "NccCheckResults"
