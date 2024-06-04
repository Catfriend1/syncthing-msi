###################
# FUNCTIONS START #
###################
function cleanUpOldDomainMsiInstall {
    $oldPath = "\\vm-dc01.cf.local\install\EdgeBrowser\117.0.2045.60\"
    $newPath = "C:\Server\Sync\Sysvol\install\Microsoft\Edge\117.0.2045.60\"
    $registryBasePath = "HKLM:\SOFTWARE\Classes\Installer\Products"
    $subkeys = Get-ChildItem -Path $registryBasePath
    foreach ($subkey in $subkeys) {
        $netPath = "$($subkey.PSPath)\SourceList\Net"
        if (Test-Path -Path $netPath) {
            $properties = Get-ItemProperty -Path $netPath
            foreach ($property in $properties.PSObject.Properties) {
                if ($property.Value -is [string] -and $property.Value -like "*$oldPath*") {
                    $newValue = $property.Value -replace [regex]::Escape($oldPath), $newPath
                    Set-ItemProperty -Path $netPath -Name $property.Name -Value $newValue
                }
            }
        }
    }
}
###################
# FUNCTIONS END   #
###################
#
#
# Check if we have patchday.
if ((Get-Date).Day -gt 5) {
	"[INFO] Nothing to do, we don't have patchday today. Stop."
    Exit 99
}
#
Get-Process -Name "msedge" -ErrorAction SilentlyContinue | ForEach-Object { Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue }
#
# Runtime Variables.
$wingetExe = (Resolve-Path -ErrorAction Stop -Path (${ENV:ProgramFiles} + "\WindowsApps\Microsoft.DesktopAppInstaller_*\winget.exe") | Select -First 1).Path
#
cleanUpOldDomainMsiInstall
#
# & $wingetExe show --accept-source-agreements --source winget --locale DE --exact --id "Microsoft.Edge" --versions
& $wingetExe install --accept-source-agreements --source winget --exact --id "Microsoft.Edge" --scope machine
& $wingetExe install --accept-source-agreements --source winget --exact --id "Microsoft.EdgeWebView2Runtime" --scope machine
#
Exit 0
