# Get physical RAM in Gb
$physicalRAM = "{0:N0}" -f ((Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory / 1gb)