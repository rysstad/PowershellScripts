#Requires -RunAsAdministrator
# Disables IE WPAD on Windows Server 2008 R2 
$HKEYUSERS = get-childitem $(Resolve-Path Registry::HKEY_USERS\) 

foreach ($userKey in $HKEYUSERS) {
    $RegPath = $userKey.PSPath
    $RegPath = $RegPath + "\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Connections\"
    
    if ($(Test-Path $RegPath)) {
        $wpadSetting = (Get-ItemProperty -LiteralPath $RegPath).DefaultConnectionSettings 
        $Type = $wpadSetting.GetType()
        if ($($Type.Name) -match "Byte") { 
            $wpadSetting[8] = 1 
            Set-ItemProperty -Path $RegPath -Name "DefaultConnectionSettings" -Value $wpadSetting 
        }
    } 
}

