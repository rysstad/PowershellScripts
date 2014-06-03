<#
.SYNOPSIS
Trace-TCPHalfOpen
.DESCRIPTION
Use NETSTAT to monitor for TCP sessions with status SYN_SENT. 
This can help identifying processes trying to connect to unreachable remote hosts. 
To terminate the script, use ctrl-c.
.EXAMPLE
.\Trace-TCPHalfOpen.ps1
.LINK
https://github.com/rysstad
.LINK
http://en.wikipedia.org/wiki/TCP_half-open
#>
While ("0" -le "1") {
  $netstatResult = netstat -no |  Select-String -SimpleMatch -Pattern "SYN_SENT" 
  if ($netstatResult -eq $null ) {
    # Write-Host "Currently no TCP connections with status SYN_SENT found" 
  } Else {
  $ConnectionFoundStr = @() 
  # Write-Host -ForegroundColor Red "TCP connections with status SYN_SENT found!"
  $netstatResult | ForEach-Object { 
    $ConnectionFoundStr +=  $_.Line  
  } 
  # Write-Host -ForegroundColor Red "Number of network connections with status SYN_SENT: " $ConnectionFoundStr.Length 
  ForEach ($ArrayLine in $ConnectionFoundStr) {
    $arrConnectionFound = @()
    $ArrayLine -Split("\s+") | ForEach-Object {
      $arrConnectionFound += $_ 
    }
    $is0861dato = Get-Date -UFormat "%Y-%m-%d %H:%M"
    Write-Host -ForegroundColor Red "Process: " (Get-Process -Id $arrConnectionFound[5]).ProcessName "- PID:" $arrConnectionFound[5] "tried to connect to" $arrConnectionFound[3] "at" $is0861dato
  }
}  

Start-Sleep -s 10
}
