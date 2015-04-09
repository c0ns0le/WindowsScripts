##########################################################
# Author: Jason DiBabbo (jason.dibabbo@outlook.com)
#
# File Name: Patch-RubyGems-2.2.3.ps1
#
# Description: A script to automate the patching of an
# issue found in RubyGems 2.2.2.
##########################################################

[CmdletBinding()]
param()

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

function Is-Admin()
{
    $identity  = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object System.Security.Principal.WindowsPrincipal( $identity )

    $principal.IsInRole( [System.Security.Principal.WindowsBuiltInRole]::Administrator )
}

if (Is-Admin)
{
    $currentDirectory = (Resolve-Path .).Path
    $destination = $env:TEMP
    $url = "https://github.com/rubygems/rubygems/releases/download/v2.2.3/rubygems-2.2.3.zip"
    $fileName = Get-FileNameFromUrl -url $url
    $fullPath = "$destination\$fileName"
    $newDirectory = "$destination\" + $fileName.Substring(0, $fileName.IndexOf('.zip'))
    Request-FileFromUrl -url $url -fileName $filename -destination $destination

    if (Test-Path $fullPath)
    {
        Write-Verbose "Extracting contents of zip file..."
        Expand-ZipFile -file $fullpath -destination $destination
        if (Test-Path $newDirectory)
        {
            Write-Verbose "Extraction complete!"
            cd $newdirectory;
            Write-Verbose "Beginning update process..."
            ruby setup.rb | Out-Null
            Write-Verbose "Patch process complete!"
            cd $currentDirectory
        }
        else
        {
            Write-Verbose "There was an error while extracting the files specified. Aborting patch process."
        }
        
    }
    else
    {
        Write-Verbose "Something went wrong while downloading the file specified. Aborting patch process."
    }
}
else
{
    Write-Verbose "To patch RubyGems, this script needs to be run in an Administrator console. Aborting."
}