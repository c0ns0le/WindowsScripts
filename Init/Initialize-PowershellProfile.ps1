##########################################################
# Author: Jason DiBabbo (jason.dibabbo@outlook.com)
#
# File Name: Initialize-PowershellProfile.ps1
#
# Description: A script to automate the generation of a 
# powershell profile. It then copies the profile in this
# repository to replace the new one.
##########################################################

[CmdletBinding()]
param()

function Initialize-PowershellProfile
{
    Write-Verbose "Initializing powershell profile..."
    New-Item -Path $Profile -Type File -Force | Out-Null
    $ProfileLocation = $Profile.Substring(0, $Profile.LastIndexOf("\") + 1)
    cp ..\Microsoft.PowerShell_profile.ps1 $ProfileLocation
    Write-Verbose "Successfully initialized powershell profile!"
}

Initialize-PowershellProfile