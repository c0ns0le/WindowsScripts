##########################################################
# Author: Jason DiBabbo (jason.dibabbo@outlook.com)
#
# File Name: Initialize-AutoHotKeyScripts.ps1
#
# Description: A script to automate the generation of
# shortcuts for all of the AutoHotKey (.ahk) scripts 
# in this repository. The shortcuts are placed in the
# startup directory.
##########################################################

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string] $AutoHotKeyScriptsLocation
)

$username = [Environment]::UserName
$startupFolder = "C:\Users\$username\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\"
$shell = New-Object -ComObject WScript.Shell
$scriptDirectory = [System.IO.Path]::GetFullPath((Join-Path (pwd) '..\AutoHotKey'))

function Initialize-AutoHotKeyScripts
{
    Write-Verbose "Getting AutoHotKey scripts..."
    $scripts = (Get-Item $AutoHotKeyScriptsLocation\*.ahk).Name
    Write-Verbose "Initializing AutoHotKey scripts..."
    Foreach ($script in $scripts)
    {
        Create-ScriptShortcutsInStartup($script)
    }

    Write-Verbose "AutoHotKey scripts successfully initialized!"
}

function Create-ScriptShortcutsInStartup($scriptName)
{
    Write-Verbose "Creating shortcut for $scriptName in the startup folder..."
    $fileNameWithoutShortcut = $scriptName.Substring(0, $scriptName.IndexOf("."))
    $shortcut = $shell.CreateShortcut("$startupFolder\$fileNameWithoutShortcut.lnk")
    $shortcut.TargetPath = "$scriptDirectory\$scriptName"
    $shortcut.Description = "Launches an Auto Hot Keys Script"
    $shortcut.Save()
    Write-Verbose "Shortcut for $scriptName successfully created!"
}

Initialize-AutoHotKeyScripts