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

Import-Module -Name FileDownloadUtilities

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