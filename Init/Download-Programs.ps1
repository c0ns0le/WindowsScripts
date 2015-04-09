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

# Helper function that gets the name
# of a file being downloaded from
# the end of a url.
Function Get-FileNameFromUrl
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [String]$url
    )

    $urlPortions = $url.Split("/")
    $fileName = $urlPortions[$urlPortions.Count - 1]

    return $fileName;
}

# Downloads a file from a url
# and saves it do a destination
# directory with the input file name.
Function Request-FileFromUrl
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [String]$url,

        [Parameter(Mandatory=$true)]
        [String]$fileName,

        [Parameter(Mandatory=$true)]
        [String]$destination
    )

    # If the directory we want to download into doesn't exist, create it
    if (!(Test-Path $destination))
    {
        Write-Verbose "'$destination' directory was not found. Creating desired destination directory."
        mkdir $destination;
    }

    # If the file we want to download already exists, then just act like we've already downloaded it
    if (Test-Path "$destination\$fileName")
    {
        Write-Verbose "File '$fileName' already exists. Aborting download."
        return
    }

    try
    {
        $webclient = New-Object System.Net.WebClient        
        Write-Verbose "Downloading $fileName from $url..."
        $webclient.DownloadFile($url, "$destination\$fileName")
        Write-Verbose "Download successful!"
    }
    catch
    {
        Write-Error "There was an error downloading the file at the specified url."
    }
}

function Download-Programs
{
    if (!(Test-Path $ProgramsFileName))
    {
        Write-Error "'$ProgramsFileName' was not found. Aborting."
        return
    }

    Write-Verbose "Loading $ProgramsFileName..."
    $programs = Get-Content $ProgramsFileName
    Write-Verbose "$ProgramsFileName loaded successfully!"

    Foreach($program in $programs)
    {
        # Ignore comment lines and newlines
        if ($program.StartsWith("#") -or $program.Length -eq 0)
        {
            continue;
        }

        $fileName = Get-FileNameFromUrl -url $program
        Write-Verbose "Downloading $fileName!"
        Request-FileFromUrl -url $program -fileName $fileName -destination $DestinationDirectory
    }

    Write-Verbose "Program downloads complete!"
}

Download-Programs