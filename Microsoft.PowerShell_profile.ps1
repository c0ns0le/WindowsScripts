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

function Write-Error($message)
{
    Write-Host $message -ForegroundColor Red
}

function hamlr() 
{
	haml-coffee -r -f xhtml -i $args
}