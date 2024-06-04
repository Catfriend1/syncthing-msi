#
# Post Install Cleanup.
Remove-Item -Path (${ENV:ProgramData} + "\Microsoft\Windows\Start Menu\Programs\Firefox Privater Modus.lnk") -Force -ErrorAction SilentlyContinue
#
# Check if we have patchday.
if ((Get-Date).Day -gt 5) {
	"[INFO] Nothing to do, we don't have patchday today. Stop."
    Exit 99
}
#
Get-Process -Name "firefox" -ErrorAction SilentlyContinue | ForEach-Object { Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue }
#
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
