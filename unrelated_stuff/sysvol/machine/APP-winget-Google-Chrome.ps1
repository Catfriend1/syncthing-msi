###################
# FUNCTIONS START #
###################
function cleanUpOldDomainMsiInstall {
    $oldPath = "\\vm-dc01.cf.local\install\Chrome\117.0.5938.150\"
    $newPath = "C:\Server\Sync\Sysvol\install\Google\Chrome\117.0.5938.150\"
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
# Runtime Variables.
$wingetExe = (Resolve-Path -ErrorAction Stop -Path (${ENV:ProgramFiles} + "\WindowsApps\Microsoft.DesktopAppInstaller_*\winget.exe") | Select -First 1).Path
#
cleanUpOldDomainMsiInstall
#
# & $wingetExe show --accept-source-agreements --source winget --locale DE --exact --id "Google.Chrome" --versions
& $wingetExe install --accept-source-agreements --source winget --exact --id "Google.Chrome" --scope machine
#
Exit 0
