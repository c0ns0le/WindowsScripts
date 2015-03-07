[CmdletBinding()]
param()

function Write-VerboseTimeStamped($message)
{
    $timeStamp = Get-Date -Format "dd-MM-yyyy HH:mm:ss"
    Write-Verbose "$timeStamp -- $message"
}

function Initialize-AutoHotKeyScripts
{
    Write-VerboseTimeStamped "Initializing AutoHotKey scripts..."
    ..\AutoHotKey\AddScriptsToStartupFolder.ps1
    Write-VerboseTimeStamped "AutoHotKey scripts successfully initialized!"
}

Initialize-AutoHotKeyScripts