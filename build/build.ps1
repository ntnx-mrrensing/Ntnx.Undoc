$OutPath = (Split-Path -path $PSScriptRoot)
$ModuleName = (Split-Path -path $OutPath -Leaf)

New-NtnxApiFunction -Method POST -ApiVersion v1 -AltVerb "Invoke" -AltNoun "NccCheck" -OutPath "$OutPath\$ModuleName\Public" -SubUrl "/ncc/checks"
New-NtnxApiFunction -Method GET -ApiVersion v1 -SubUrl "/license" -OutPath "$OutPath\$ModuleName\Public"