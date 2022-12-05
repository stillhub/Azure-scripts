# Script that creates a report of last login times for Azure accounts.
# Script created by Jared Stillwell
# Version: 1.0

$Cred = Get-Credential
Connect-MsolService -Credential $Cred
Connect-AzureAD -Credential $Cred

$Users = Get-MsolUser -all
$Headers = "DisplayName`tUserPrincipalName`tLicense`tLastLogon" >>C:\Temp\AzureLastloginUsers.txt
ForEach ($User in $Users){
    $UPN = $User.UserPrincipalName
    $LoginTime = Get-AzureAdAuditSigninLogs -top 1 -filter "userprincipalname eq '$UPN'" | select CreatedDateTime
    $NewLine = $User.DisplayName + "`t" + $User.UserPrincipalName + "`t" + $User.Licenses.AccountSkuId + "`t" + $LoginTime.CreatedDateTime
    $NewLine >>C:\Temp\AzureLastloginUsers.txt
}