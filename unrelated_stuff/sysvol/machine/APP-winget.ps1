# Prerequisites
## Winget
### https://github.com/microsoft/winget-cli/releases
## VCLibs
### https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx
#### XAML
##### https://learn.microsoft.com/en-us/windows/iot/iot-enterprise/deployment/install-winget-windows-iot
###### https://www.nuget.org/packages/Microsoft.UI.Xaml/
####### https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.8.6
#
# Runtime Variables.
$installedVersion = [version] (Get-AppxPackage -Name "Microsoft.DesktopAppInstaller" -ErrorAction Stop).Version
$targetVersion = [version] "1.22.11261.0"
#
"[INFO] App installedVersion=[" + $installedVersion + "], targetVersion=[" + $targetVersion + "]"
if ($installedVersion -ge $targetVersion) {
    "[INFO] App already installed and up2date."
    Exit 0
}
#
$installRoot = $PSScriptRoot + "\..\install\winget"
#
Add-AppxPackage -Path ($installRoot + "\Microsoft.VCLibs.x64.14.00.Desktop.appx")
Add-AppxPackage -Path ($installRoot + "\Microsoft.UI.Xaml.2.8.appx")
Add-AppxPackage -Path ($installRoot + "\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle")
Add-AppxProvisionedPackage -Online -PackagePath ($installRoot + "\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle") -LicensePath ($installRoot + "\License.xml")
#
Exit 0
