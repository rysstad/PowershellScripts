 $TranscriptFile = $env:TEMP + "\PowershellTranscript-" + (Get-Date -Format yyyy-MM-dd_HH-mm).ToString() + ".log"
 Start-Transcript $TranscriptFile -Verbose