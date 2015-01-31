echo "
           ______________________________________
  ________|                                      |_______
  \       |        DJ, script that shit!         |      /
   \      |                                      |     /
   /      |______________________________________|     \
  /__________)                                (_________\

"

Set-Alias l ls
Set-Alias c cls
Set-Alias sublime sublime_text.exe

function Get-UserName()
{
    return [Environment]::UserName
}

function Get-CurrentDirectoryPath()
{
    return (Get-Item -Path ".").FullName
}

function Is-Admin()
{
    $identity  = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object System.Security.Principal.WindowsPrincipal( $identity )

    $principal.IsInRole( [System.Security.Principal.WindowsBuiltInRole]::Administrator )
}

function Update-Path()
{
	$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
}