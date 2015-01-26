# Script for new installations of Windows by Jason DiBabbo (jason.dibabbo@outlook.com)
# Purpose: To automate downloading as many developer tools and programs as possible.

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
choco install vcl
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
choco install expresso
choco install ccleaner
choco install skype
choco install teamviewer

#Patch Ruby 2.2.2
echo "========================================="
echo "Patching RubyGems for Ruby v2.2.2"
echo "========================================="
..\Patching\RubyGems-2.2.3-Patch.ps1