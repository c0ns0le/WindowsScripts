##########################################################
# Author: Jason DiBabbo (jason.dibabbo@outlook.com)
#
# File Name: Install-Packages.ps1
#
# Description: A script to automate the installation of
# various tools with new installations of Windows.
##########################################################

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string] $PackagesFileName,

    [switch] $InstallChocolatey
)

Import-Module -Name ChocolateyUtilities

Function Install-ChocolateyPackages
{
    Write-Verbose "Loading $packagesFileName..."
    $packages = Get-Content $PackagesFileName

    Foreach ($package in $packages)
    {
        # Ignore comment lines and newlines
        if ($package.StartsWith("#") -or $package.Length -eq 0)
        {
            continue;
        }

        Write-Verbose "Checking if $package is available..."
        if (Get-ChocolateyPackageExists($package))
        {
            Install-ChocolateyPackage($package)
        }
        else
        {
            Write-Verbose "Skipping $package..."
        }
    }
}

if ($InstallChocolatey)
{
    Install-Chocolatey
}

Install-ChocolateyPackages
