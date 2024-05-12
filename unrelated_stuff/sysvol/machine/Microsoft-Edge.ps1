# Microsoft Edge
## Disable Services
Set-Service -Name "edgeupdate" -StartupType Disabled -Status Stopped
Set-Service -Name "edgeupdatem" -StartupType Disabled -Status Stopped
Set-Service -Name "MicrosoftEdgeElevationService" -StartupType Disabled -Status Stopped
##
## Disable Scheduled Tasks
Get-ScheduledTask | Where-Object { $_.TaskName -match "MicrosoftEdgeUpdateTask.*" } | Disable-ScheduledTask | Out-Null
#
Exit 0
