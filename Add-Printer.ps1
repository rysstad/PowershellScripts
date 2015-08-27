$PrinterPath = "\\printerServer\printerShare" 
$PrinterName = "PrinterName" 

$wmiNet = new-Object -com WScript.Network 
$wmiNet.AddWindowsPrinterConnection($PrinterPath)   
# Set as default
(New-Object -ComObject WScript.Network).SetDefaultPrinter($PrinterName) 
# List all printers
# (New-Object -ComObject WScript.Network).EnumPrinterConnections()