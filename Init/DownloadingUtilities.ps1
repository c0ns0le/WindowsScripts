##########################################################
# Author: Jason DiBabbo (jason.dibabbo@outlook.com)
#
# File Name: LoggingUtilities.ps1
#
# Description: A script containing functions for
# downloading files over HTTP.
##########################################################

. .\LoggingUtilities.ps1

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
        Write-Error "There was an error downloading the file at the specified url."
    }
}

function GetFileNameFromUrl($url)
{
    $urlPortions = $url.Split("/")
    $filename = $urlPortions[$urlPortions.Count - 1]

    return $filename;
}