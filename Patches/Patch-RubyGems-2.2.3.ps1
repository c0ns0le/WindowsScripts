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

function Write-VerboseTimeStamped($message)
{
    $timeStamp = Get-Date -Format "dd-MM-yyyy HH:mm:ss"
    Write-Verbose "$timeStamp -- $message"
}

function Write-Good($message)
{
    Write-Host $message -ForegroundColor Green -BackgroundColor Black
}

function Write-Bad($message)
{
    Write-Host "ERROR: $message" -ForegroundColor Red -BackgroundColor Black
}

function UserIsAdministrator()
{
    $identity  = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object System.Security.Principal.WindowsPrincipal( $identity )

    $principal.IsInRole( [System.Security.Principal.WindowsBuiltInRole]::Administrator )
}

function GetFileNameFromUrl($url)
{
    $urlPortions = $url.Split("/")
    $filename = $urlPortions[$urlPortions.Count - 1]

    return $filename;
}

function Expand-ZipFile($file, $destination)
{
    # If the directory we want to unzip into doesn't exist, create it
    if (!(Test-Path $destination))
    {
        Write-VerboseTimeStamped "Directory was not found. Creating desired destination directory."
        mkdir $destination;
    }

    # If the file in question doesn't exist, quit early
    if (!(Test-Path $file))
    {
        Write-VerboseTimeStamped "Designated compressed file was not found. Quitting extraction."
        return
    }

    Unblock-File $file
    $shell = New-Object -ComObject Shell.Application
    $zip = $shell.NameSpace($file)
    foreach ($item in $zip.Items())
    {
        $shell.NameSpace($destination).CopyHere($item)
    }
}

function Download-File($url, $filename, $destination)
{
    # If the directory we want to unzip into doesn't exist, create it
    if (!(Test-Path $destination))
    {
        Write-VerboseTimeStamped "Directory was not found. Creating desired destination directory."
        mkdir $destination;
    }

    # If the file we want to download already exists, then just act like we've already downloaded it
    if (Test-Path "$destination\$filename")
    {
        Write-VerboseTimeStamped "File already exists. Aborting download."
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

if (UserIsAdministrator)
{
    $destination = $env:TEMP
    $url = "https://github.com/rubygems/rubygems/releases/download/v2.2.3/rubygems-2.2.3.zip"
    $filename = GetFileNameFromUrl -url $url
    $fullpath = "$destination\$filename"
    $newdirectory = "$destination\" + $filename.Substring(0, $filename.IndexOf('.zip'))
    Download-File -url $url -filename $filename -destination $destination

    if (Test-Path $fullpath)
    {
        Write-VerboseTimeStamped "Extracting contents of zip file..."
        Expand-ZipFile -file $fullpath -destination $destination
        if (Test-Path $newdirectory)
        {
            Write-VerboseTimeStamped "Extraction complete!"
            cd $newdirectory;
            Write-VerboseTimeStamped "Beginning update process..."
            ruby setup.rb | Out-Null
            Write-VerboseTimeStamped "Patch process complete!"
        }
        else
        {
            Write-VerboseTimeStamped "There was an error while extracting the files specified. Aborting patch process."
        }
        
    }
    else
    {
        Write-VerboseTimeStamped "Something went wrong while downloading the file specified. Aborting patch process."
    }
}
else
{
    Write-VerboseTimeStamped "To patch RubyGems, this script needs to be run in an Administrator console. Aborting."
}