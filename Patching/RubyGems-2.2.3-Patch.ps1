# Patch for RubyGems 2.2.2 by Jason DiBabbo (jason.dibabbo@outlook.com)

# Step 1: Check if the user is in an admin console. If yes, continue. If no, quit.
# Step 2: Download zip file from https://github.com/rubygems/rubygems/releases/download/v2.2.3/rubygems-2.2.3.zip
# Step 3: Extract zip file into directory
# Step 4: Navigate into extracted directory
# Step 5: Run 'ruby setup.rb'

function UserIsAdministrator()
{
    $identity  = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object System.Security.Principal.WindowsPrincipal( $identity )

    $principal.IsInRole( [System.Security.Principal.WindowsBuiltInRole]::Administrator )
}

function GetFileNameFromUrl($url)
{
    $urlPortions = $url.Split("/")
    $filename = $urlPortions[$urlPortions.Count - 1]

    return $filename;
}

function Expand-ZipFile($file, $destination)
{
    # If the directory we want to unzip into doesn't exist, create it
    if (!(Test-Path $destination))
    {
        echo "Directory was not found. Creating desired destination directory."
        mkdir $destination;
    }

    # If the file in question doesn't exist, quit early
    if (!(Test-Path $file))
    {
        echo "Designated compressed file was not found. Quitting extraction."
        return
    }

    Unblock-File $file
    $helper = New-Object -ComObject Shell.Application
    $files = $helper.NameSpace($file).Items()
    $helper.NameSpace($destination).CopyHere($files)
}

function Download-File($url, $filename, $destination)
{
    # If the directory we want to unzip into doesn't exist, create it
    if (!(Test-Path $destination))
    {
        echo "Directory was not found. Creating desired destination directory."
        mkdir $destination;
        echo ""
    }

    # If the file we want to download already exists, then just act like we've already downloaded it
    if (Test-Path "$destination\$filename")
    {
        echo "File already exists. Aborting download."
        return
    }

    try
    {
        $webclient = New-Object System.Net.WebClient
        
        echo "Downloading $filename from $url..."
        $webclient.DownloadFile($url, "$destination\$filename")
        echo "Download successful!"
    }
    catch
    {
        echo "There was an error downloading the file at the specified url."
    }
}

if (UserIsAdministrator)
{
    $destination = "C:\Temp\"
    $url = "https://github.com/rubygems/rubygems/releases/download/v2.2.3/rubygems-2.2.3.zip"
    $filename = GetFileNameFromUrl -url $url
    Download-File -url $url -filename $filename -destination $destination

    if (Test-Path "$destination\$filename")
    {
        echo "Extracting contents of zip file..."
        Expand-ZipFile -file $filename -destination $destination
        echo "Extraction complete!"
        cd $destination;
        $newdirectoryname = $filename.Substring(0, $filename.IndexOf(".zip"))
        
        cd $newdirectoryname;
        echo "Beginning update process..."
        ruby setup.rb
    }
    else
    {
        echo "Patching process aborted."
    }
}
else
{
    echo "To patch RubyGems, this script needs to be run in an Administrator console. Aborting."
}