# Remove the "modern app" version of Skype. Tested on Win 10 preview. 
Get-AppxPackage -Name Microsoft.SkypeApp | Remove-AppxPackage