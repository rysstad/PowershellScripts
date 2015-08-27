# Create object reference to Get-Host
$pshost = get-host
# create reference to the console’s UI.RawUI child object
$pswindow = $pshost.ui.rawui
# Adjust the buffer first:
$newsize = $pswindow.buffersize
$newsize.height = 9999
$newsize.width = 200
$pswindow.buffersize = $newsize
# Adjust the Window size
$newsize = $pswindow.windowsize
$newsize.height = 60
$newsize.width = 200
$pswindow.windowsize = $newsize
