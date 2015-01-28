# Script for new installations of Windows by Jason DiBabbo (jason.dibabbo@outlook.com)
# Purpose: To automate downloading as many developer tools and programs as possible.

#Save the path location of where the install script is
$cwd = (Get-Item -Path ".").FullName

#Download Chocolatey
echo "========================================="
echo "Downloading Chocolatey Package Manager"
echo "========================================="
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

#Download Chocolatey packages
echo "========================================="
echo "Installing Chocolatey Packages"
echo "========================================="
choco install python
choco install ruby
choco install jdk8
choco install strawberryperl
choco install nodejs
choco install 7zip
choco install autohotkey
choco install cpu-z
choco install hwmonitor
choco install svn
choco install firefox
choco install googlechrome
choco install vlc
choco install sublimetext3
choco install winscp
choco install greenshot
choco install putty
choco install fiddler4
choco install brackets
choco install chocolateygui
choco install atom
choco install eclipse
choco install ffmpeg
choco install youtube-dl
choco install ccleaner
choco install skype
choco install teamviewer

echo "Refreshing environment PATH variables..."
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")

#Patch Ruby 2.2.2
echo "========================================="
echo "Patching RubyGems for Ruby v2.2.2"
echo "========================================="
..\Patching\RubyGems-2.2.3-Patch.ps1

#Go back to the installation script directory
cd $cwd

#Set the Powershell Profile
echo "========================================="
echo "Setting up Powershell Profile"
echo "========================================="
New-Item -Path $Profile -Type File -Force
$ProfileLocation = $Profile.Substring(0, $Profile.LastIndexOf("\") + 1)
cp ..\Microsoft.PowerShell_profile.ps1 $ProfileLocation

#Update the Latest AutoHotKey Scripts to run on startup
echo "========================================="
echo "Setting up AutoHotKey Script Automation"
echo "========================================="
..\AutoHotKey\AddScriptsToStartupFolder.ps1