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

function Write-VerboseTimeStamped($message)
{
    $timeStamp = Get-Date -Format "dd-MM-yyyy HH:mm:ss"
    Write-Verbose "$timeStamp -- $message"
}

function ChocolateyPackage-Exists($packageName)
{
    $packages = Invoke-Expression "Chocolatey search $packageName"
    if ($packages -eq "No packages found.")
    {
        Write-VerboseTimeStamped "$packageName DOES NOT exist in repositories."
        return $false;
    }
    else
    {
        Write-VerboseTimeStamped "$packageName DOES exist in repositories."
        return $true;
    }
}

function Install-Chocolatey
{
    Write-VerboseTimeStamped "Installing Chocolatey..."
    iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
}

function Install-ChocolateyPackages
{
    Write-VerboseTimeStamped "Loading $packagesFileName..."
    $packages = Get-Content $PackagesFileName

    Foreach ($package in $packages)
    {
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

function Install-ChocolateyPackage($packageName)
{
    Write-VerboseTimeStamped "Installing $packageName"
    Invoke-Expression "Choco install $packageName" | Out-Null
    if ($LASTEXITCODE -eq 0)
    {
        Write-VerboseTimeStamped "Successfully installed $packageName!"
    }
    else
    {
        Write-VerboseTimeStamped "Failed to install $packageName :-("
    }
}

function Refresh-EnvironmentVariables
{
    Write-VerboseTimeStamped "Refreshing environment variables..."
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
}

function Patch-RubyGems
{
    Write-VerboseTimeStamped "Patching RubyGems 2.2.2 to 2.2.3..."
    ..\Patching\RubyGems-2.2.3-Patch.ps1
}

#Save the path location of where the install script is
$cwd = (Get-Item -Path ".").FullName

if ($InstallChocolatey)
{
    Install-Chocolatey
}

Install-ChocolateyPackages

if ($FixRuby)
{
    Patch-RubyGems
    cd $cwd
}

#Update the Latest AutoHotKey Scripts to run on startup
#echo "========================================="
#echo "Setting up AutoHotKey Script Automation"
#echo "========================================="
#..\AutoHotKey\AddScriptsToStartupFolder.ps1