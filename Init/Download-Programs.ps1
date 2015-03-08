##########################################################
# Author: Jason DiBabbo (jason.dibabbo@outlook.com)
#
# File Name: Download-Programs.ps1
#
# Description: A script to automate the downloading of 
# various '.exe' files that I need to install with every
# new installation of Windows that are not available
# on package managers like Chocolatey.
##########################################################

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string] $ProgramsFileName,
    [Parameter(Mandatory=$true)]
    [string] $DestinationDirectory
)

function Write-VerboseTimeStamped($message)
{
    $timeStamp = Get-Date -Format "dd-MM-yyyy HH:mm:ss"
    Write-Verbose "$timeStamp -- $message"
}

function GetFileNameFromUrl($url)
{
    $urlPortions = $url.Split("/")
    $filename = $urlPortions[$urlPortions.Count - 1]

    return $filename;
}

function Download-File($url, $filename, $destination)
{
    # If the directory we want to download into doesn't exist, create it
    if (!(Test-Path $destination))
    {
        Write-VerboseTimeStamped "'$destination' directory was not found. Creating desired destination directory."
        mkdir $destination;
    }

    # If the file we want to download already exists, then just act like we've already downloaded it
    if (Test-Path "$destination\$filename")
    {
        Write-VerboseTimeStamped "File '$filename' already exists. Aborting download."
        return
    }

    try
    {
        $webclient = New-Object System.Net.WebClient
        
        
        Write-VerboseTimeStamped "Downloading $filename from $url..."
        $webclient.DownloadFile($url, "$destination\$filename")
        Write-VerboseTimeStamped "Download successful!"
    }
    catch
    {
        Write-VerboseTimeStamped "There was an error downloading the file at the specified url."
    }
}

function Download-Programs
{
    if (!(Test-Path $ProgramsFileName))
    {
        Write-Error "'$ProgramsFileName' was not found. Aborting."
        return
    }

    Write-VerboseTimeStamped "Loading $ProgramsFileName..."
    $programs = Get-Content $ProgramsFileName
    Write-VerboseTimeStamped "$ProgramsFileName loaded successfully!"

    Foreach($program in $programs)
    {
        # Ignore comment lines and newlines
        if ($program.StartsWith("#") -or $program.Length -eq 0)
        {
            continue;
        }

        $fileName = GetFileNameFromUrl -url $program
        Download-File -url $program -filename $fileName -destination $DestinationDirectory
    }

    Write-VerboseTimeStamped "Program downloads complete!"
}

Download-Programs