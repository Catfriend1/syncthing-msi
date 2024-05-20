###################
# FUNCTIONS START #
###################
function GetInstalledVersion {
    param (
        [parameter(Mandatory = $true)]
        [string]
        $binPath
    )
    #
    try {
        $versionInfo = (Get-Item -Path $binInstalledExecutable -ErrorAction Stop).VersionInfo
        $productVersion = "$($versionInfo.FileMajorPart).$($versionInfo.FileMinorPart).$($versionInfo.FileBuildPart).$($versionInfo.FilePrivatePart)"
    } catch {
        $productVersion = "0.0"
    }
    Return [version]$productVersion
}


function GetVersionFromMSI {
    param (
        [parameter(Mandatory = $true)]
        [string]
        $msiPackage
    )
    #
    try {
        $windowsInstaller  = New-Object -ComObject WindowsInstaller.Installer
        $database = $windowsInstaller.OpenDatabase($msiPackage, 0)
        $query = "SELECT `Value` FROM `Property` WHERE `Property`='ProductVersion'"
        $view = $database.OpenView($query)
        $view.Execute() | Out-Null
        $record = $view.Fetch()
        $version = $record.StringData(1)
    } catch {
        Write-Host ("[ERROR] " + $_)
    } finally {
        $record = $null
        $view = $null
        $database = $null
        $windowsInstaller  = $null
        [System.GC]::Collect()
        [System.GC]::WaitForPendingFinalizers()
    }
    #
    Return [version]$version
}
###################
# FUNCTIONS END   #
###################
#
#
# Consts.
$binInstaller = Resolve-Path -ErrorAction Stop -Path ($PSScriptRoot + "\..\install\Thunderbird\Thunderbird Setup 115.11.0.msi")
$binInstallerArg = ('/i "' + $binInstaller + '" /qb /norestart REBOOT=ReallySuppress TASKBAR_SHORTCUT=false DESKTOP_SHORTCUT=false INSTALL_MAINTENANCE_SERVICE=false PREVENT_REBOOT_REQUIRED=true')
$binInstalledExecutable = $ENV:ProgramFiles + "\Mozilla Thunderbird\thunderbird.exe"
#
# Runtime Variables.
$installedVersion = GetInstalledVersion -binPath $binInstalledExecutable
$targetVersion = GetVersionFromMSI -msiPackage $binInstaller
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
$process = Start-Process -Wait -PassThru -FilePath "msiexec.exe" -ArgumentList $binInstallerArg 
if ($process.ExitCode -ne 0) {
    "[INFO] Install FAILED: " + $process.ExitCode
    Exit $process.ExitCode
}
#
"[INFO] Install SUCCESS"
#
Exit 0
