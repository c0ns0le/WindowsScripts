##########################################################
# Author: Jason DiBabbo (jason.dibabbo@outlook.com)
#
# File Name: LoggingUtilities.ps1
#
# Description: A script containing functions for
# installing packages with Chocolatey.
##########################################################

. .\LoggingUtilities.ps1 

function Install-Chocolatey
{
    Write-VerboseTimeStamped "Installing Chocolatey..."
    try
    {
        iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
        Write-VerboseTimeStamped "Successfully installed Chocolatey!"
    }
    catch
    {
        Write-Error "Something went wrong while installing Chocolatey."
    }
}

function ChocolateyPackage-Exists($packageName)
{
    try
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
    catch
    {
        Write-Error "An exception occurred while trying to query the Chocolatey repository."
        return $false
    }
}

function Install-ChocolateyPackage($packageName)
{
    Write-VerboseTimeStamped "Installing $packageName"
    try
    {
        Invoke-Expression "Choco install $packageName" | Out-Null
        if ($LASTEXITCODE -eq 0)
        {
            Write-VerboseTimeStamped "Successfully installed $packageName!"
        }
        else
        {
            Write-VerboseTimeStamped "Failed to install $packageName. You may have used the wrong package name."
        }
    }
    catch
    {
        Write-Error "Something went wrong while trying to install $packageName. It was not installed."
    }
}

function Refresh-EnvironmentVariables
{
    Write-VerboseTimeStamped "Refreshing environment variables..."
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
    Write-VerboseTimeStamped "Done!"
}