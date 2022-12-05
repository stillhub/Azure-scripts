# Script that forces an Azure Active Directory Sync
# Script created by Jared Stillwell
# Version: 1.0

#Calling Powershell as Admin and setting Execution Policy to Bypass to avoid Cannot run Scripts error
([switch]$Elevated)
function CheckAdmin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
if ((CheckAdmin) -eq $false) {
    if ($elevated) {
        # could not elevate, quit
    }
    else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -ExecutionPolicy Bypass -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition)) | Out-Null
    }
    Exit
}

CheckAdmin
Start-ADSyncSyncCycle -PolicyType Delta