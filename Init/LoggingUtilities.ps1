##########################################################
# Author: Jason DiBabbo (jason.dibabbo@outlook.com)
#
# File Name: LoggingUtilities.ps1
#
# Description: A script containing functions for logging
# purposes.
##########################################################

function Write-VerboseTimeStamped($message)
{
    $timeStamp = Get-Date -Format "dd-MM-yyyy HH:mm:ss"
    Write-Verbose "$timeStamp -- $message"
}