###########################################################
# Author: Jason DiBabbo (jason.dibabbo@outlook.com)
#
# File Name: FileDownloadUtilities.psm1
#
# Description: A PowerShell module containing wrapper
# functionality for various file downloading actions.
###########################################################

# Expands a .zip file into a designated
# directory. If the designated directory
# does not exist, it will be created.
Function Expand-ZipFile
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$file,

        [Parameter(Mandatory=$true)]
        [string]$destination
    )

    # If the directory we want to unzip into doesn't exist, create it
    if (!(Test-Path $destination))
    {
        Write-Verbose "Directory was not found. Creating desired destination directory."
        mkdir $destination;
    }

    # If the file in question doesn't exist, quit early
    if (!(Test-Path $file))
    {
        Write-Error "Designated compressed file was not found. Quitting extraction."
        return
    }

    Unblock-File $file
    $shell = New-Object -ComObject Shell.Application
    $zip = $shell.NameSpace($file)
    Foreach ($item in $zip.Items())
    {
        $shell.NameSpace($destination).CopyHere($item)
    }
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