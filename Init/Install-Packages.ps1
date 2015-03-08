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

    [bool] $InstallChocolatey = $false,
    [bool] $FixRuby = $false
)

. .\ChocolateyUtilities.ps1

function Install-ChocolateyPackages
{
    Write-VerboseTimeStamped "Loading $packagesFileName..."
    $packages = Get-Content $PackagesFileName

    Foreach ($package in $packages)
    {
        # Ignore comment lines and newlines
        if ($package.StartsWith("#") -or $package.Length -eq 0)
        {
            continue;
        }

        Write-VerboseTimeStamped "Checking if $package is available..."
        if (ChocolateyPackage-Exists($package))
        {
            Install-ChocolateyPackage($package)
        }
        else
        {
            Write-VerboseTimeStamped "Skipping $package..."
        }
    }
}

function Patch-RubyGems
{
    Write-VerboseTimeStamped "Patching RubyGems 2.2.2 to 2.2.3..."
    ..\Patches\Patch-RubyGems-2.2.3.ps1
}

if ($InstallChocolatey)
{
    Install-Chocolatey
}

Install-ChocolateyPackages

if ($FixRuby)
{
    Patch-RubyGems
}