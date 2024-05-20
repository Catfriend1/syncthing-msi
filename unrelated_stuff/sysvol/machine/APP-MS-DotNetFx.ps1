###################
# FUNCTIONS START #
###################
function GetInstalledVersion {
    param (
        [parameter(Mandatory = $true)]
        [string]
        $markerFile
    )
    #
    try {
        $productVersion = Get-Content -ErrorAction Stop -Raw -Path $markerFile
    } catch {
        $productVersion = "0"
    }
    Return $productVersion
}


function GetVersionFromEXE {
    param (
        [parameter(Mandatory = $true)]
        [string]
        $exePackage
    )
    #
    try {
        $version = (Get-Item -ErrorAction Stop -Path $exePackage).VersionInfo.ProductVersion
    } catch {
        $version = "0"
    }
    #
    Return $version
}
###################
# FUNCTIONS END   #
###################
#
#
# Consts.
$binInstaller = Resolve-Path -ErrorAction Stop -Path ($PSScriptRoot + "\..\install\Microsoft\DotNetFx\windowsdesktop-runtime-8.0.5-win-x64.exe")
$binInstallerArg = "/install /quiet /norestart"
$binInstalledVersionFile = $ENV:ProgramFiles + "\dotnet\microsoft-dotnet-sdk.packageversion"
#
# Runtime Variables.
$installedVersion = GetInstalledVersion -markerFile $binInstalledVersionFile
$targetVersion = GetVersionFromEXE -exePackage $binInstaller
if ($targetVersion -eq $null) {
    "[ERROR] Could not get targetVersion from binInstaller=[" + $binInstaller + "]"
    Exit 99
}
#
"[INFO] App installedVersion=[" + $installedVersion + "], targetVersion=[" + $targetVersion + "]"
if ($installedVersion -ge $targetVersion) {
    "[INFO] App already installed and up2date."
    Exit 0
}
#
"[INFO] Exec INSTALL/UPDATE: " + $installedVersion + " < " + $targetVersion
"[INFO] Exec installer: " + $binInstallerArg
$process = Start-Process -Wait -PassThru -FilePath $binInstaller -ArgumentList $binInstallerArg 
if ($process.ExitCode -ne 0) {
    "[INFO] Install FAILED: " + $process.ExitCode
    Exit $process.ExitCode
}
#
"[INFO] Install SUCCESS"
$targetVersion | Out-File -Encoding ASCII -NoNewline -FilePath $binInstalledVersionFile
#
Exit 0
