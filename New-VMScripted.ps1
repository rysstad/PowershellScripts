
function New-VMScripted {
 [CmdletBinding()]
  param
  (
    [string]$VMFolder,
    [string]$VMISO,
    [string]$VMNetwork,
    [string]$VMName,
    [UInt64]$VMMemory,
    [UInt64]$VMDiskSize
  )

    New-VM -Name $VMName -BootDevice CD -MemoryStartupBytes $VMMemory -SwitchName $VMNetwork -Path $VMFolder -NoVHD
    New-VHD -Path "$VMFolder\$VMName\Virtual Hard Disks\$VMName-Disk1.vhdx" -SizeBytes $VMDiskSize
    Add-VMHardDiskDrive -VMName $VMName -Path "$VMLocation\$VMName\Virtual Hard Disks\$VMName-Disk1.vhdx" 
    Set-VMDvdDrive -VMName $VMName -Path $VMISO
    Start-VM -VMName $VMName
}

# Example of usage (Note that the VMMemory and VMDiskSize parameters must not be put in "'s...)
New-VMScripted -VMFolder "D:\VirtualMachines" -VMISO "D:\LabSources\ISOs\CentOS-7.0-1406-x86_64-NetInstall.iso" -VMNetwork "LaptopLapPrivate" -VMName "CentOS-Router" -VMMemory 512MB -VMDiskSize 10GB -Verbose

