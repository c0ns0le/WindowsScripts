##########################################################
# Author: Jason DiBabbo (jason.dibabbo@outlook.com)
#
# File Name: Copy-PowershellModules.ps1
#
# Description: A script to automate the copying of 
# the PowerShell modules in this repository to the
# local computer.
##########################################################

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string] $CustomPowerShellModulesLocation
)

$standardPowerShellModulesLocation = "$home\Documents\WindowsPowerShell\Modules"

# If the public modules directory hasn't been created yet,
# create it.
if (!(Test-Path($standardPowerShellModulesLocation)))
{
    mkdir $standardPowerShellModulesLocation
}

$myModules = Get-ChildItem -Path $CustomPowerShellModulesLocation

Foreach ($module in $myModules)
{
    $newModuleLocation = "$standardPowerShellModulesLocation\$module"
    if (Test-Path($newModuleLocation))
    {
        Write-Verbose "Module '$module' already exists. Skipping."
        continue
    }

    mkdir $newModuleLocation
    $moduleFiles = Get-ChildItem "$CustomPowerShellModulesLocation\$module"
    Foreach ($moduleFile in $moduleFiles)
    {
        Copy-Item -Path $CustomPowerShellModulesLocation\$module\$moduleFile -Destination $newModuleLocation
    }
}
