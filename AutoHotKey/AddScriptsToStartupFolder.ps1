# Script to ensure AHK scripts automatically run on startup by Jason DiBabbo (jason.dibabbo@outlook.com)

# Step 1: Get a list of all AHK files in the current directory
# Step 2: Create a shortcut for each file in the list
# Step 3: Cut and paste the shortcut into the startup folder

echo "Creating Auto Hot Key script startup shortcuts"

function Write-Good($message)
{
    Write-Host $message -ForegroundColor Green -BackgroundColor Black
}

$startupFolder = "C:\Users\Jason\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\"
$currentDirectory = Get-Location
$cwd = $currentDirectory.Path
$shell = New-Object -ComObject WScript.Shell

$currentDirectoryItems = Get-ChildItem -Path "."
$ahkScripts = @()

foreach ($item in $currentDirectoryItems)
{
    if ($item.Attributes -ne "Directory")
    {
        $fileParts = $item.Name.Split(".")
        $fileExtension = $fileParts[$fileParts.Count - 1]

        if ($fileExtension -eq "ahk")
        {
            $ahkScripts += $item.Name
        }
    }
}

foreach ($item in $ahkScripts)
{
    echo "Creating shorcut for $item..."
    $shortcut = $shell.CreateShortcut("$startupFolder\$item.lnk")
    $shortcut.TargetPath = "$cwd\$item"
    $shortcut.Description = "Launches an Auto Hot Keys Script"
    $shortcut.Save()
    Write-Good "Shortcut created successfully!"
}