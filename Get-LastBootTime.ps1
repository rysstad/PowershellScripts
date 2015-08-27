function Get-LastBootTime {
    # returns last boot time and date as System.DateTime
    (Get-Date) - $([timespan]::FromMilliseconds([Environment]::TickCount ) )
}
