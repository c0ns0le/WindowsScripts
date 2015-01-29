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

function Get-UserName()
{
    return [Environment]::UserName
}

function Get-CurrentPath()
{
    return (Get-Item -Path ".").FullName
}

function Update-Path()
{
	$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
}