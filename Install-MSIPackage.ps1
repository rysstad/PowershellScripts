$msiPackageToInstall = "<path to .msi>"
# save log from installation to temp file 
$tmpFile = [System.IO.Path]::GetTempFileName()
Start-Process msiexec -ArgumentList "/i $msiPackageToInstall /qn /L*v $tmpFile" -NoNewWindow -Wait
