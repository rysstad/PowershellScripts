#Requires -RunAsAdministrator
# Disables certificate CRL checking on Windows Server 2008 R2 
# More info here: http://blogs.msdn.com/b/chaun/archive/2014/05/01/best-practices-for-crl-checking-on-sharepoint-servers.aspx 
$HKEYUSERS = get-childitem $(Resolve-Path Registry::HKEY_USERS\) 

foreach ($userKey in $HKEYUSERS) {
    $RegPath = $userKey.PSPath
    $RegPath = $RegPath + "\Software\Microsoft\Windows\CurrentVersion\WinTrust\Trust Providers\Software Publishing\"
    
    if ($(Test-Path $RegPath)) {
            Set-ItemProperty -Path $RegPath -Name "State" -Value 146944
        }
    } 

