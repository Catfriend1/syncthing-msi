# Runtime Variables.
$wingetExe = (Resolve-Path -ErrorAction Stop -Path (${ENV:ProgramFiles} + "\WindowsApps\Microsoft.DesktopAppInstaller_*\winget.exe") | Select -First 1).Path
#
& $wingetExe install --accept-source-agreements --source winget --exact --id "Mozilla.Firefox" --scope machine
#
attrib +s +h "${ENV:PUBLIC}\Desktop\Firefox.lnk"
#
# Disable Services
Set-Service -Name "MozillaMaintenance" -StartupType Disabled -Status Stopped
#
Exit 0
