[CmdletBinding()]
param()

function Write-VerboseTimeStamped($message)
{
    $timeStamp = Get-Date -Format "dd-MM-yyyy HH:mm:ss"
    Write-Verbose "$timeStamp -- $message"
}

function Initialize-PowershellProfile
{
    Write-VerboseTimeStamped "Initializing powershell profile..."
    New-Item -Path $Profile -Type File -Force | Out-Null
    $ProfileLocation = $Profile.Substring(0, $Profile.LastIndexOf("\") + 1)
    cp ..\Microsoft.PowerShell_profile.ps1 $ProfileLocation
    Write-VerboseTimeStamped "Successfully initialized powershell profile!"
}

Initialize-PowershellProfile