$sqlioTestStarted = (Get-Date -Format "yyyy-MM-dd HH:mm:ss").ToString()
$testDuration = "360"  # string, not number...
$sqlioTestFile = "d:\temp\sqlioTestFile.dat"
$sqlioTestFileSizeGB = 75
$sqlioResultCSV = "c:\temp\sqlioResult_" + $env:COMPUTERNAME + ".csv"
$sqlioTestFileSizeBytes = $sqlioTestFileSizeGB * 1000000000
$sqlio                          =   Resolve-Path "C:\temp\SQLIO\sqlio.exe"
$sqlioDuration                  =   "-s" + $testDuration
$sqlioRandomOrSequential        =   "-frandom"   # "-frandom" or "-fsequential"
$sqlioIOSize                    =   "-b64"        #  8KB is the typical IO for OLTP workloads. 512KB is common for Reporting, Data Warehousing.
$sqlioThreads                   =   "-t2"
$sqlioqueueDepth                =   "-o4"
$sqliCaptureLatencyInformation  =   "-LS"
$waitTime                       =   20    #  Number of seconds to wait between each test.
 
 
 
 
Function Parse-SQLIOOutputWriteToCSV {
 
  [Cmdletbinding()]
  param (
 
    [parameter(Mandatory=$true)] [String[]] $sqlioResult,
    [parameter(Mandatory=$true)] [String[]] $sqliBuffer,
    [parameter(Mandatory=$true)] [String[]] $testDuration,
    [parameter(Mandatory=$true)] [String[]] $sqlioTestFileSizeGB,
    [parameter(Mandatory=$true)] [String[]] $sqlioReadOrWrite
 
  )
 
  Begin {
    Write-Verbose "Started function Parse-SQLIOOutputWriteToCSV"
  }
 
  Process {
  
 
      # Parse output, add to CSV-file
    $newlineChr = [Environment]::NewLine
 
    # $array = $sqlioResult.Split($newlineChr)
 
    $sqlioResult | ForEach-Object {
 
      # Get IOs/sec value
      $regExp = "\d+"
      if ($_ -match "IOs/sec:" ) {
          $_ -match $regExp | Out-Null
          $ioSec = $Matches[0]
      }
 
      # Get MBs/sec value
      $regExp = "\d+"
      if ($_ -match "MBs/sec:" ) {
          $_ -match $regExp | Out-Null
          $MBsSec = $Matches[0]
      }
 
      # Get Min_Latency(ms) value
      $regExp = "\d+"
      if ($_ -match "Min_Latency" ) {
          $_ -match $regExp | Out-Null
          $Min_Latency = $Matches[0]
      }
 
      # Get Avg_Latency value
      $regExp = "\d+"
      if ($_ -match "Avg_Latency" ) {
          $_ -match $regExp | Out-Null
          $Avg_Latency = $Matches[0]
      }
 
      # Get Max_Latency value
      $regExp = "\d+"
      if ($_ -match "Max_Latency" ) {
          $_ -match $regExp | Out-Null
          $Max_Latency = $Matches[0]
      }
 
      # Get test file size
      $regExp = "\d+"
      if ($_ -match "using current size" ) {
          $_ -match $regExp | Out-Null
          $TestFileSizeMb = $Matches[0]
      }
 
    }
    Add-Content -LiteralPath $sqlioResultCSV -Value " $sqlioTestStarted , $env:COMPUTERNAME , $sqlioReadOrWrite , $sqliBuffer , $testDuration , $TestFileSizeMb , $ioSec , $MBsSec , $Min_Latency , $Avg_Latency , $Max_Latency "
    # csv header:
    # TestStartedDate, ComputerName, SQLIO_ReadOrWrite, SQLIO_BufferUsage, SQLIO_TestDuration, SQLIO_TestFileSizeMB, SQLIO_IOperSecond, SQLIO_MBperSecond, SQLIO_MinLatency, SQLIO_AvgLatency, SQLIO_MaxLatency
  }
  
  End {
    Write-Verbose "End of function Parse-SQLIOOutputWriteToCSV"
  }
} # End of function Parse-SQLIOOutputWriteToCSV
 
 
 
##########################
## Read-test, No buffering
Remove-Item -Force -Path $sqlioTestFile -ErrorAction SilentlyContinue
& $env:windir\System32\fsutil.exe "file" "createnew" $sqlioTestFile $sqlioTestFileSizeBytes | Out-Null
& $env:windir\System32\fsutil.exe "file" "setvaliddata" $sqlioTestFile $sqlioTestFileSizeBytes | Out-Null
$sqlioReadOrWrite               =   "-kR"        # "-kR" or "-kW"
$sqliBuffer                     =   "-BN"   # set buffering -B<[N|Y|H|S]> (N=none, Y=all, H=hdwr, S=sfwr)
# Write-Output "Running command: $sqlio $sqlioDuration $sqlioReadOrWrite $sqlioRandomOrSequential $sqlioIOSize $sqlioThreads $sqlioqueueDepth $sqliCaptureLatencyInformation $sqliBuffer $sqliotestfile"
$sqlioResult = & $sqlio $sqlioDuration $sqlioReadOrWrite $sqlioRandomOrSequential $sqlioIOSize $sqlioThreads $sqlioqueueDepth $sqliCaptureLatencyInformation $sqliBuffer $sqliotestfile
Start-Sleep -Seconds 2
Remove-Item -Path $sqliotestfile -Force -ErrorAction Continue
Parse-SQLIOOutputWriteToCSV -sqlioResult $sqlioResult -sqliBuffer $sqliBuffer -testDuration $testDuration -sqlioTestFileSizeGB $sqlioTestFileSizeGB -sqlioReadOrWrite $sqlioReadOrWrite 
$sqlioResultTime = (Get-Date -Format "yyyy-MM-dd_HH-mm-ss").ToString()
$sqlioResultFile = "c:\temp\sqlioResult_$sqlioResultTime.log"
$sqlioResult | Out-File -FilePath $sqlioResultFile
 
 
##########################
# Wait a bit between tests
Start-Sleep -Seconds $waitTime
 
##########################
## Write-test, No buffering
Remove-Item -Force -Path $sqlioTestFile -ErrorAction SilentlyContinue
& $env:windir\System32\fsutil.exe "file" "createnew" $sqlioTestFile $sqlioTestFileSizeBytes | Out-Null
& $env:windir\System32\fsutil.exe "file" "setvaliddata" $sqlioTestFile $sqlioTestFileSizeBytes | Out-Null
$sqlioReadOrWrite               =   "-kW"        # "-kR" or "-kW"
$sqliBuffer                     =   "-BN"   # set buffering -B<[N|Y|H|S]> (N=none, Y=all, H=hdwr, S=sfwr)
# Write-Output "Running command: $sqlio $sqlioDuration $sqlioReadOrWrite $sqlioRandomOrSequential $sqlioIOSize $sqlioThreads $sqlioqueueDepth $sqliCaptureLatencyInformation $sqliBuffer $sqliotestfile"
$sqlioResult = & $sqlio $sqlioDuration $sqlioReadOrWrite $sqlioRandomOrSequential $sqlioIOSize $sqlioThreads $sqlioqueueDepth $sqliCaptureLatencyInformation $sqliBuffer $sqliotestfile
Start-Sleep -Seconds 2
Remove-Item -Force -Path $sqlioTestFile -ErrorAction SilentlyContinue
Parse-SQLIOOutputWriteToCSV -sqlioResult $sqlioResult -sqliBuffer $sqliBuffer -testDuration $testDuration -sqlioTestFileSizeGB $sqlioTestFileSizeGB -sqlioReadOrWrite $sqlioReadOrWrite
$sqlioResultTime = (Get-Date -Format "yyyy-MM-dd_HH-mm-ss").ToString()
$sqlioResultFile = "c:\temp\sqlioResult_$sqlioResultTime.log"
$sqlioResult | Out-File -FilePath $sqlioResultFile
 
 
##########################
# Wait a bit between tests
Start-Sleep -Seconds $waitTime
 
##########################
## Read-test, both hardware and software buffering
Remove-Item -Force -Path $sqlioTestFile -ErrorAction SilentlyContinue
& $env:windir\System32\fsutil.exe "file" "createnew" $sqlioTestFile $sqlioTestFileSizeBytes | Out-Null
& $env:windir\System32\fsutil.exe "file" "setvaliddata" $sqlioTestFile $sqlioTestFileSizeBytes | Out-Null
$sqlioReadOrWrite               =   "-kR"        # "-kR" or "-kW"
$sqliBuffer                     =   "-BY"   # set buffering -B<[N|Y|H|S]> (N=none, Y=all, H=hdwr, S=sfwr)
# Write-Output "Running command: $sqlio $sqlioDuration $sqlioReadOrWrite $sqlioRandomOrSequential $sqlioIOSize $sqlioThreads $sqlioqueueDepth $sqliCaptureLatencyInformation $sqliBuffer $sqliotestfile"
$sqlioResult = & $sqlio $sqlioDuration $sqlioReadOrWrite $sqlioRandomOrSequential $sqlioIOSize $sqlioThreads $sqlioqueueDepth $sqliCaptureLatencyInformation $sqliBuffer $sqliotestfile
Start-Sleep -Seconds 2
Remove-Item -Path $sqliotestfile -Force -ErrorAction Continue
Parse-SQLIOOutputWriteToCSV -sqlioResult $sqlioResult -sqliBuffer $sqliBuffer -testDuration $testDuration -sqlioTestFileSizeGB $sqlioTestFileSizeGB -sqlioReadOrWrite $sqlioReadOrWrite
$sqlioResultTime = (Get-Date -Format "yyyy-MM-dd_HH-mm-ss").ToString()
$sqlioResultFile = "c:\temp\sqlioResult_$sqlioResultTime.log"
$sqlioResult | Out-File
