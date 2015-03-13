﻿###########################################################
# Author: Jason DiBabbo (jason.dibabbo@outlook.com)
#
# File Name: ChocolateyUtilities.psm1
#
# Description: A PowerShell module containing wrapper
# functionality for streamlining the process to install
# packages via Chocolatey (https://chocolatey.org).
###########################################################

# Refreshes the current environment variables
# to thier latest values. 
Function Update-EnvironmentVariables
{
    [CmdletBinding()]
    Param()

    Write-Verbose "Refreshing environment variables..."
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
    Write-Verbose "Done!"
}

# Installs Chocolatey package manager
# from https://chocolatey.org
Function Install-Chocolatey
{
    [CmdletBinding()]
    Param()

    Write-Verbose "Installing Chocolatey..."
    iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
    Write-Verbose "Successfully installed Chocolatey!"
}

# Determines if a package exists
# in the Chocolatey repositories.
# Remark: Not 100% chance of accuracy
Function Get-ChocolateyPackageExists
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [String]$packageName
    )

    $packages = Invoke-Expression "Chocolatey search $packageName"
    if ($packages -eq "No packages found.")
    {
        Write-Verbose "$packageName DOES NOT exist in repositories."
        return $false;
    }
    else
    {
        Write-Verbose "$packageName DOES exist in repositories."
        return $true;
    }
}

# Installs a pacakage from the
# Chocolatey package manager.
Function Install-ChocolateyPackage
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [String]$packageName
    )

    Write-Verbose "Installing $packageName"
    Invoke-Expression "Choco install $packageName" | Out-Null
    if ($LASTEXITCODE -eq 0)
    {
        Write-Verbose "Successfully installed $packageName!"
    }
    else
    {
        Write-Verbose "Failed to install $packageName. You may have used the wrong package name."
    }
}