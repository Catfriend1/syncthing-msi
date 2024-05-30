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
# Check if Citrix Workspace App is installed.
if (-not (Test-Path -Path (${ENV:ProgramFiles(x86)} + "\Citrix\ICA Client\wfica32.exe"))) {
	"[INFO] Citrix Workspace is not installed."
	Exit 99
}
#
# Disable Services
Set-Service -Name "appprotectionsvc" -StartupType Disabled -Status Stopped
Set-Service -Name "CWAUpdaterService" -StartupType Disabled -Status Stopped
#
# Disable autoruns
## AnalyticsSrv
### "C:\Program Files (x86)\Citrix\ICA Client\Receiver\AnalyticsSrv.exe" /Startup
##
## ConnectionCenter
### "C:\Program Files (x86)\Citrix\ICA Client\concentr.exe" /Startup
##
## InstallHelper
### "C:\Program Files (x86)\Citrix\Citrix Workspace 2403\InstallHelper.exe"
##
## Redirector
### "C:\Program Files (x86)\Citrix\ICA Client\redirector.exe" /Startup
#
@("AnalyticsSrv", "ConnectionCenter", "InstallHelper", "Redirector") |% {
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run" -Name $_ -ErrorAction SilentlyContinue
}
#
Remove-Item -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Active Setup\Installed Components\{60f15951-e7ef-11ea-b28e-c4b301b9ed33}" -Recurse -Force -ErrorAction SilentlyContinue
#
# Disable kernel and driver services
sc.exe config ctxapdriver start= disabled
sc.exe config ctxapinject start= disabled
sc.exe config ctxapusbfilter start= disabled
sc.exe config ctxusbm start= disabled
#
# Set CWA policies
## https://support.citrix.com/article/CTX133565/how-to-configure-default-device-access-behavior-of-workspace-app-for-windows
## https://support.citrix.com/article/CTX332846/citrix-workspace-app-an-account-is-not-configured-please-contact-your-administrator
## https://docs.citrix.com/de-de/citrix-virtual-apps-desktops/policies/reference/hdx-registry-settings.html
## https://rahuljindalmyit.blogspot.com/2023/01/managing-citrix-client-selective-trust.html
## https://admx.help/?Category=Citrix_Receiver&Policy=FullArmor.Policies.16ECAFDB_AA9E_4C5A_BAB8_7DDBD88F56FB::POLx64_CreateClientSelectiveTrustKeys
##
## Disable Customer Experience Improvement Program
Reg-Add -Path "HKLM:\SOFTWARE\WOW6432Node\Citrix\ICA Client\CEIP" -Name "Enable_CEIP" -Value 0 -Type DWord
##
## Disable add storefront server popup
Reg-Add -Path "HKLM:\Software\WOW6432Node\Citrix\Dazzle" -Name "AllowAddStore " -Value "N" -Type String
##
## Set ClientSelectiveTrustKeys
### Disable client drive redirection
Reg-Add -Path "HKLM:\SOFTWARE\WOW6432Node\Policies\Citrix\ICA Client\Client Selective Trust" -Name "CreatedByPolicy " -Value 1 -Type DWord
$importRegPath = $PSScriptRoot + "\Citrix-Workspace-App.reg"
Invoke-Expression "regedit /s `"$importRegPath`"" | Out-Null
#
# Uninstall self-service plugin to prevent "no store added popup".
wmic product where "name like 'Self-Service Plug-in'" call uninstall /nointeractive
#
Exit 0
