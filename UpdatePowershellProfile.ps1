$ProfileLocation = $Profile.Substring(0, $Profile.LastIndexOf("\") + 1)
cp .\Microsoft.PowerShell_profile.ps1 $ProfileLocation