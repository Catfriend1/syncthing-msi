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
Reg-Add -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0 -Type Dword
Reg-Add -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarModePrevious" -Value 2 -Type Dword
Reg-Add -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "TraySearchBoxVisible" -Value 0 -Type Dword
Reg-Add -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "TraySearchBoxVisibleOnAnyMonitor" -Value 0 -Type Dword
#
Exit 0
