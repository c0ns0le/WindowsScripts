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

. .\DownloadingUtilities.ps1

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