$dirSize = (Get-ChildItem -file -Recurse | Measure-Object length -sum).sum/1mb
$dirSize = [math]::Round($dirSize)
Write-Output "$(Get-Location):   $dirSize Mb"