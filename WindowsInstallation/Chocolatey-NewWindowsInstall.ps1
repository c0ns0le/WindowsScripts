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
choco install git
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
choco install expresso
choco install ccleaner
choco install skype
choco install teamviewer
