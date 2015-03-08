# Initialization Directory 
This is the directory for initializing a new installation of Windows with programs and packages from various web sources and the Windows Package Manager Chocolatey (<https://chocolatey.org/>). Also here are some scripts for automatically generating a powershell profile and syncing it with the one in this repository, placing shortcuts to my AutoHotKeys scripts in the startup folder, and patching an error located in RubyGems 2.2.2 (the latest version offered through Chocolatey).

## Changing the packages to be installed
To change the list of packages downloaded from Chocolatey, modify the "Packages.txt" file, or create your own. 

## Changing the programs to be downloaded
To change the list of .exe files downloaded, modify the "Programs.txt" file, or create your own.

## To launch the automated setup
To run the automated setup, execute the "Setup.bat" file. It will automatically ask for elevated permission and execute the powershell scripts in verbose mode with some pre-defined parameters. 
