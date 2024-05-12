# Google Chrome
## Disable Services
Set-Service -Name "GoogleChromeElevationService" -StartupType Disabled -Status Stopped
Set-Service -Name "gupdate" -StartupType Disabled -Status Stopped
Set-Service -Name "gupdatem" -StartupType Disabled -Status Stopped
Get-Service | Where-Object { $_.Name -match "GoogleUpdaterInternalService.*" } | Set-Service -StartupType Disabled -Status Stopped
Get-Service | Where-Object { $_.Name -match "GoogleUpdaterService.*" } | Set-Service -StartupType Disabled -Status Stopped
##
## Disable Scheduled Tasks
Get-ScheduledTask | Where-Object { $_.TaskName -match "GoogleUpdaterTaskSystem.*" } | Disable-ScheduledTask | Out-Null
#
Exit 0
