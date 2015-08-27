# Set Sharepoint DeveloperDashboard DisplayLevel to On
$DeveloperDashboard = [Microsoft.SharePoint.Administration.SPWebService]::ContentService.DeveloperDashboardSettings
$DeveloperDashboard.DisplayLevel = 'On'
$DeveloperDashboard.TraceEnabled = $true
$DeveloperDashboard.Update()

# Turn off Sharepoint DeveloperDashboard 
$DeveloperDashboard = [Microsoft.SharePoint.Administration.SPWebService]::ContentService.DeveloperDashboardSettings
$DeveloperDashboard.DisplayLevel = 'Off'
$DeveloperDashboard.TraceEnabled = $False
$DeveloperDashboard.Update()

# Set Sharepoint *2010* DeveloperDashboard DisplayLevel to OnDemand
$DeveloperDashboard = [Microsoft.SharePoint.Administration.SPWebService]::ContentService.DeveloperDashboardSettings
$DeveloperDashboard.DisplayLevel = 'OnDemand'
$DeveloperDashboard.TraceEnabled = $true
$DeveloperDashboard.Update()