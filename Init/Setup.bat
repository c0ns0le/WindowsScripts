::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Author: Jason DiBabbo (jason.dibabbo@outlook.com)
::
:: File Name: Init.bat
::
:: Description: A batch file to automatically execute 
:: the included powershell scripts to download my 
:: desired packages, fix the ruby bug, get my profile
:: set up, and to make shortcuts to all of my .ahk 
:: scripts in the startup folder.
::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Get admin permission to make sure everything we do works
:: I'll be straight up - this next bit of batch script felt
:: super sketchy to include, but it works. 
:: Check http://stackoverflow.com/questions/1894967/how-to-request-administrator-access-inside-a-batch-file
:: for the original posting.

@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

:: First (after getting admin permission), set the powershell execution policy so that I can execute scripts
@powershell -NoProfile -NoLogo -Command "Set-ExecutionPolicy RemoteSigned -Force"
@powershell -NoProfile -NoLogo -Command ".\CopyPowershellModules.ps1 -CustomPowerShellModulesLocation ..\PowershellModules"
@powershell -NoProfile -NoLogo -Command ".\Install-Packages.ps1 -PackagesFileName Programs.txt -InstallChocolatey -Verbose"
@powershell -NoProfile -NoLogo -Command ".\Patch-RubyGems-2.2.3.ps1 -Verbose"
@powershell -NoProfile -NoLogo -Command ".\Initialize-PowershellProfile.ps1 -Verbose"
@powershell -NoProfile -NoLogo -Command ".\Initialize-AutoHotKeyScripts.ps1 -AutoHotKeyScriptsLocation ..\AutoHotKey -Verbose"
@powershell -NoProfile -NoLogo -Command ".\Download-Programs.ps1 -Verbose -ProgramsFileName Programs.txt -DestinationDirectory C:\Temp"