#
#
###################
# FUNCTIONS START #
###################
function Reg-Add {
    param (
        [parameter(Mandatory = $true)] [string] $Path,
        [parameter(Mandatory = $true)] [string] $Name,
        [parameter(Mandatory = $true)] [string] $Value,
        [parameter(Mandatory = $true)] [Microsoft.Win32.RegistryValueKind] $Type
    )
    #
    $regAddPath = $Path -Replace ":", ""
    if (-not (Test-Path -Path $Path)) {
        Invoke-Expression "REG ADD `"$regAddPath`" /f" | Out-Null
    }
    Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type -Force
}
###################
# FUNCTIONS END   #
###################
#
#
$json = Get-Content -Raw -Path ($psScriptRoot + "\managed-bookmarks.json") -ErrorAction Stop
#
Reg-Add -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "ManagedBookmarks" -Value $json -Type String
#
Reg-Add -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "ManagedFavorites" -Value $json -Type String
#
Reg-Add -Path "HKLM:\SOFTWARE\Policies\Mozilla\Firefox" -Name "ManagedBookmarks" -Value $json -Type String
#
Exit 0
