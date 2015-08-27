Get-ChildItem | Select-Object Name,LastWriteTime,@{Name="Size Mb"; Expression = {[math]::round($_.Length /1Mb, 2)}} 