$json = Get-Content -Raw -Path ($psScriptRoot + "\managed-bookmarks.json") -ErrorAction Stop
#
$registryPath = "HKLM:\SOFTWARE\Policies\Google\Chrome"
New-Item -Path $registryPath -Force | Out-Null
Set-ItemProperty -Path $registryPath -Name "ManagedBookmarks" -Value $json -Type String
#
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
New-Item -Path $registryPath -Force | Out-Null
Set-ItemProperty -Path $registryPath -Name "ManagedFavorites" -Value $json -Type String
#
$registryPath = "HKLM:\Software\Policies\Mozilla\Firefox"
New-Item -Path $registryPath -Force | Out-Null
Set-ItemProperty -Path $registryPath -Name "ManagedBookmarks" -Value $json -Type String
#
Exit 0
